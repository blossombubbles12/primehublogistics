-- PrimeHub Logistics - Payload CMS schema (matches Payload 3 + Postgres adapter naming)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================= USERS =================
CREATE TABLE IF NOT EXISTS users (
  id serial PRIMARY KEY,
  name text NOT NULL,
  role text NOT NULL DEFAULT 'customer',
  status text NOT NULL DEFAULT 'active',
  email text NOT NULL UNIQUE,
  hash text,
  salt text,
  reset_password_token text,
  reset_password_expiration timestamptz,
  login_attempts numeric DEFAULT 0,
  lock_until timestamptz,
  api_key text,
  api_key_index text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ================= MEDIA =================
CREATE TABLE IF NOT EXISTS media (
  id serial PRIMARY KEY,
  alt text NOT NULL,
  credit text,
  filename text,
  filesize numeric,
  mime_type text,
  url text,
  width numeric,
  height numeric,
  sizes jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ================= BLOG CATEGORIES =================
CREATE TABLE IF NOT EXISTS blog_categories (
  id serial PRIMARY KEY,
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description jsonb,
  image_id integer REFERENCES media(id),
  featured boolean NOT NULL DEFAULT false,
  status text NOT NULL DEFAULT 'active',
  sort_order numeric NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ================= CONTACT MESSAGES =================
CREATE TABLE IF NOT EXISTS contact_messages (
  id serial PRIMARY KEY,
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  subject text NOT NULL DEFAULT 'General Enquiry',
  message text NOT NULL,
  status text NOT NULL DEFAULT 'new',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
-- ================= POSTS =================
CREATE TABLE IF NOT EXISTS posts (
  id serial PRIMARY KEY,
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  excerpt text,
  content jsonb,
  hero_image_id integer REFERENCES media(id),
  category_id integer REFERENCES blog_categories(id),
  publish_date timestamptz NOT NULL,
  featured boolean NOT NULL DEFAULT false,
  status text NOT NULL DEFAULT 'draft',
  author_name text NOT NULL,
  author_role text,
  author_avatar_id integer REFERENCES media(id),
  author_bio text,
  seo_meta_title text,
  seo_meta_description text,
  seo_keywords text,
  seo_og_image_id integer REFERENCES media(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS posts_gallery (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id integer REFERENCES posts(id) ON DELETE CASCADE,
  _order integer,
  image_id integer REFERENCES media(id),
  alt text,
  caption text
);
CREATE TABLE IF NOT EXISTS posts_tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id integer REFERENCES posts(id) ON DELETE CASCADE,
  _order integer,
  tag text
);

-- ================= SHIPPING METHODS =================
CREATE TABLE IF NOT EXISTS shipping_methods (
  id serial PRIMARY KEY,
  name text NOT NULL,
  description text,
  base_fee numeric NOT NULL DEFAULT 2000,
  estimated_delivery text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS shipping_methods_zone_fees (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _order integer,
  _parent_id integer REFERENCES shipping_methods(id) ON DELETE CASCADE,
  zone text NOT NULL,
  fee numeric NOT NULL
);

-- ================= LOCATIONS =================
CREATE TABLE IF NOT EXISTS locations (
  id serial PRIMARY KEY,
  name text NOT NULL,
  type text NOT NULL DEFAULT 'hub',
  address text,
  city text,
  country text NOT NULL DEFAULT 'Netherlands',
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
-- ================= SHIPMENTS =================
CREATE TABLE IF NOT EXISTS shipments (
  id serial PRIMARY KEY,
  tracking_number text NOT NULL UNIQUE,
  sender_name text NOT NULL,
  sender_company text,
  sender_phone text NOT NULL,
  sender_email text,
  recipient_name text NOT NULL,
  recipient_company text,
  recipient_phone text NOT NULL,
  recipient_email text,
  origin_id integer REFERENCES locations(id),
  destination_id integer REFERENCES locations(id),
  current_location_id integer REFERENCES locations(id),
  status text NOT NULL DEFAULT 'created',
  delivery_service_id integer REFERENCES shipping_methods(id),
  estimated_delivery timestamptz,
  notes text,
  package_description text,
  package_content text,
  package_quantity numeric NOT NULL DEFAULT 1,
  package_weight numeric,
  package_weight_unit text NOT NULL DEFAULT 'kg',
  package_length numeric,
  package_width numeric,
  package_height numeric,
  package_declared_value numeric,
  package_reference_number text,
  package_is_fragile boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
-- ================= TRACKING EVENTS =================
CREATE TABLE IF NOT EXISTS tracking_events (
  id serial PRIMARY KEY,
  shipment_id integer REFERENCES shipments(id),
  status text NOT NULL,
  date_time timestamptz NOT NULL,
  location_id integer REFERENCES locations(id),
  description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS shipments_rels (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "order" integer,
  parent_id integer,
  path text,
  tracking_events_id integer REFERENCES tracking_events(id)
);
CREATE INDEX IF NOT EXISTS idx_shipments_rels_parent ON shipments_rels(parent_id);
-- ================= GLOBALS =================
CREATE TABLE IF NOT EXISTS site_settings (
  id serial PRIMARY KEY,
  site_name text NOT NULL DEFAULT 'PrimeHub Logistics',
  site_description text,
  logo integer REFERENCES media(id),
  favicon integer REFERENCES media(id),
  contact_email text,
  contact_phone text,
  address_street text,
  address_city text DEFAULT 'Amsterdam',
  address_state text,
  address_postal_code text,
  address_country text DEFAULT 'Netherlands',
  social_links_facebook text,
  social_links_instagram text,
  social_links_twitter text,
  social_links_linkedin text,
  currency text DEFAULT 'EUR',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS header (
  id serial PRIMARY KEY,
  announcement_bar_enabled boolean NOT NULL DEFAULT false,
  announcement_bar_text text,
  announcement_bar_link text,
  announcement_bar_link_label text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS header_nav_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id integer REFERENCES header(id) ON DELETE CASCADE,
  _order integer,
  label text NOT NULL,
  link text NOT NULL,
  type text NOT NULL DEFAULT 'link',
  highlighted boolean NOT NULL DEFAULT false
);
CREATE TABLE IF NOT EXISTS header_nav_items_children (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id uuid REFERENCES header_nav_items(id) ON DELETE CASCADE,
  _order integer,
  label text NOT NULL,
  link text NOT NULL
);

CREATE TABLE IF NOT EXISTS footer (
  id serial PRIMARY KEY,
  description text,
  copyright text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS footer_columns (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id integer REFERENCES footer(id) ON DELETE CASCADE,
  _order integer,
  title text NOT NULL
);
CREATE TABLE IF NOT EXISTS footer_columns_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id uuid REFERENCES footer_columns(id) ON DELETE CASCADE,
  _order integer,
  label text NOT NULL,
  link text NOT NULL
);
CREATE TABLE IF NOT EXISTS footer_bottom_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id integer REFERENCES footer(id) ON DELETE CASCADE,
  _order integer,
  label text NOT NULL,
  link text NOT NULL
);

CREATE TABLE IF NOT EXISTS seo_settings (
  id serial PRIMARY KEY,
  default_title text,
  title_template text,
  default_description text,
  default_keywords text,
  og_image integer REFERENCES media(id),
  twitter_handle text,
  google_site_verification text,
  google_analytics_id text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS shipping_settings (
  id serial PRIMARY KEY,
  free_shipping_threshold numeric NOT NULL DEFAULT 100,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS shipping_settings_zones (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  _parent_id integer REFERENCES shipping_settings(id) ON DELETE CASCADE,
  _order integer,
  name text NOT NULL,
  key text NOT NULL,
  cities text,
  states text,
  is_active boolean NOT NULL DEFAULT true
);

-- ================= DEFAULT GLOBAL ROWS =================
INSERT INTO site_settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;
INSERT INTO header (id) VALUES (1) ON CONFLICT (id) DO NOTHING;
INSERT INTO footer (id) VALUES (1) ON CONFLICT (id) DO NOTHING;
INSERT INTO seo_settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;
INSERT INTO shipping_settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;