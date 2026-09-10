import crypto from "crypto";
import { Pool } from "pg";

// Usage: set ADMIN_PASSWORD / MANAGER_PASSWORD (+ DATABASE_URI) env vars, then:
//   node scripts/reset-admin-password.mjs
// No credentials are stored in this file (keep it that way).

const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD;
const MANAGER_PASSWORD = process.env.MANAGER_PASSWORD;
if (!ADMIN_PASSWORD || !MANAGER_PASSWORD) {
  console.error("Set ADMIN_PASSWORD and MANAGER_PASSWORD env vars first.");
  process.exit(1);
}

const p = new Pool({
  connectionString: process.env.DATABASE_URI,
  ssl: { rejectUnauthorized: false },
});

const pbkdf2 = (password, salt) =>
  new Promise((resolve, reject) =>
    crypto.pbkdf2(password, salt, 25000, 512, "sha256", (err, raw) =>
      err ? reject(err) : resolve(raw.toString("hex")),
    ),
  );

const users = [
  { email: "admin@primehublogistics.com", password: ADMIN_PASSWORD, role: "admin" },
  { email: "manager@primehublogistics.com", password: MANAGER_PASSWORD, role: "manager" },
];

for (const u of users) {
  const salt = (await new Promise((res, rej) => crypto.randomBytes(32, (e, b) => (e ? rej(e) : res(b))))).toString("hex");
  const hash = await pbkdf2(u.password, salt);
  await p.query(
    `UPDATE users SET hash = $1, salt = $2, login_attempts = 0, lock_until = NULL, status = 'active', role = $3, updated_at = now() WHERE email = $4`,
    [hash, salt, u.role, u.email],
  );
  console.log(`SET  ${u.email}  (pbkdf2 hash + salt, lock cleared)`);
}

console.log("\nAll users:");
const all = await p.query(
  "SELECT email, role, status, login_attempts, (lock_until IS NOT NULL AND lock_until > now()) AS locked, length(hash) AS hash_len FROM users ORDER BY id",
);
for (const r of all.rows)
  console.log(` - ${r.email} | role=${r.role} | status=${r.status} | attempts=${r.login_attempts} | locked=${r.locked} | hashLen=${r.hash_len}`);

await p.end();
