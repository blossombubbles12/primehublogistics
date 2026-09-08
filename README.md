# PrimeHub Logistics

A logistics management platform built with [Next.js](https://nextjs.org) and [Payload CMS](https://payloadcms.com).

## Getting Started

First, install dependencies:

```bash
pnpm install
```

Then, run the development server:

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Project Structure

- `app/` — Next.js App Router pages and layouts
- `collections/` — Payload CMS collections (Users, Posts, Shipments, etc.)
- `components/` — Shared React components
- `globals/` — Payload global sections (SiteSettings, Header, Footer, etc.)
- `hooks/` — Custom React hooks
- `lib/` — Utility libraries and configurations
- `providers/` — React context providers
- `scripts/` — Seed and build scripts

## Configuration

Copy `.env.example` to `.env.local` and configure your environment variables:

```bash
cp .env.example .env.local
```

## Scripts

| Command | Description |
|---|---|
| `pnpm dev` | Start development server |
| `pnpm build` | Build for production |
| `pnpm start` | Start production server |
| `pnpm lint` | Run ESLint |
| `pnpm lint:fix` | Fix ESLint issues |
| `pnpm format` | Format with Prettier |
| `pnpm typecheck` | Run TypeScript type checking |
| `pnpm payload` | Start Payload CMS admin |
| `pnpm seed` | Seed the database |

## Tech Stack

- **Next.js** 16.x — React framework
- **Payload CMS** 3.x — Headless CMS
- **PostgreSQL** — Database via `@payloadcms/db-postgres`
- **Tailwind CSS** 4.x — Styling
- **Radix UI** — Accessible component primitives
- **pnpm** — Package manager

## Deployment

The project is optimized for deployment on [Vercel](https://vercel.com). See the [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
