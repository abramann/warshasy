-- database/supabase_database_creation.sql
-- ============================================
-- WARSHASY DATABASE SCHEMA (UPDATED - DYNAMIC DATA)
-- ============================================
-- All data fields are now stored in database tables
-- No ENUMs for cities, services, etc.

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. CITIES TABLE (replaces city ENUM)
-- ============================================
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  name_ar TEXT NOT NULL UNIQUE,
  name_en TEXT NOT NULL UNIQUE,
  is_active BOOLEAN DEFAULT TRUE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. CITY AREAS/REGIONS TABLE (replaces hardcoded regions)
-- ============================================
CREATE TABLE city_areas (
  id SERIAL PRIMARY KEY,
  city_id INTEGER REFERENCES cities(id) ON DELETE CASCADE NOT NULL,
  area_name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(city_id, area_name)
);

-- ============================================
-- 3. SERVICE CATEGORIES TABLE (replaces category ENUM)
-- ============================================
CREATE TABLE service_categories (
  id SERIAL PRIMARY KEY,
  name_ar TEXT NOT NULL UNIQUE,
  name_en TEXT NOT NULL UNIQUE,
  description TEXT,
  icon_url TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 4. SERVICES TABLE (replaces service_type ENUM)
-- ============================================
CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES service_categories(id) ON DELETE CASCADE NOT NULL,
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(category_id, name_ar)
);

-- ============================================
-- 5. USERS TABLE (UPDATED - uses foreign keys instead of ENUMs)
-- ============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  city_id INTEGER REFERENCES cities(id),
  area_id INTEGER REFERENCES city_areas(id),
  avatar_url TEXT,
  bio TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 6. USER SERVICES TABLE (UPDATED)
-- ============================================
CREATE TABLE user_services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  service_id INTEGER REFERENCES services(id) ON DELETE CASCADE NOT NULL,
  description TEXT,
  experience_years INTEGER CHECK (experience_years >= 0),
  hourly_rate NUMERIC(10, 2) CHECK (hourly_rate >= 0),
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, service_id)
);

-- ============================================
-- 7. CHAT ROOMS TABLE (unchanged)
-- ============================================
CREATE TABLE chat_rooms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  user2_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  last_message TEXT,
  last_message_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user1_id, user2_id),
  CHECK (user1_id < user2_id)
);

-- ============================================
-- 8. MESSAGES TABLE (unchanged)
-- ============================================
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  room_id UUID REFERENCES chat_rooms(id) ON DELETE CASCADE NOT NULL,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 9. OTP SESSIONS TABLE (unchanged)
-- ============================================
CREATE TABLE otp_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone TEXT NOT NULL,
  otp_code TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (expires_at > created_at)
);

-- ============================================
-- 10. DEVICE SESSIONS TABLE (unchanged)
-- ============================================
CREATE TABLE device_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  device_id TEXT NOT NULL,
  session_token TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ,
  last_seen_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Cities indexes
CREATE INDEX idx_cities_active ON cities(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_cities_name_ar ON cities(name_ar);
CREATE INDEX idx_cities_display_order ON cities(display_order, name_ar);

-- City areas indexes
CREATE INDEX idx_city_areas_city ON city_areas(city_id);
CREATE INDEX idx_city_areas_active ON city_areas(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_city_areas_name ON city_areas(area_name);

-- Service categories indexes
CREATE INDEX idx_service_categories_active ON service_categories(is_active) 
  WHERE is_active = TRUE;
CREATE INDEX idx_service_categories_order ON service_categories(display_order, name_ar);

-- Services indexes
CREATE INDEX idx_services_category ON services(category_id);
CREATE INDEX idx_services_active ON services(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_services_name_ar ON services(name_ar);

-- Users indexes
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_city ON users(city_id);
CREATE INDEX idx_users_area ON users(area_id);
CREATE INDEX idx_users_active ON users(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- User services indexes
CREATE INDEX idx_user_services_user ON user_services(user_id);
CREATE INDEX idx_user_services_service ON user_services(service_id);
CREATE INDEX idx_user_services_available ON user_services(is_available) 
  WHERE is_available = TRUE;
CREATE INDEX idx_user_services_search ON user_services(service_id, is_available) 
  WHERE is_available = TRUE;

-- Chat indexes
CREATE INDEX idx_chat_rooms_user1 ON chat_rooms(user1_id);
CREATE INDEX idx_chat_rooms_user2 ON chat_rooms(user2_id);
CREATE INDEX idx_chat_rooms_last_message ON chat_rooms(last_message_at DESC NULLS LAST);

-- Messages indexes
CREATE INDEX idx_messages_room ON messages(room_id, created_at DESC);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_unread ON messages(room_id, is_read) WHERE is_read = FALSE;

-- Auth indexes
CREATE INDEX idx_otp_sessions_phone ON otp_sessions(phone);
CREATE INDEX idx_otp_sessions_expires ON otp_sessions(expires_at);
CREATE INDEX idx_otp_sessions_unused ON otp_sessions(phone, otp_code)
  WHERE used_at IS NULL;

CREATE UNIQUE INDEX idx_device_sessions_user_device
  ON device_sessions(user_id, device_id);
CREATE UNIQUE INDEX idx_device_sessions_token
  ON device_sessions(session_token);
CREATE INDEX idx_device_sessions_user ON device_sessions(user_id);
CREATE INDEX idx_device_sessions_expires ON device_sessions(expires_at)
  WHERE expires_at IS NOT NULL;

-- ============================================
-- AUTOMATIC TIMESTAMP TRIGGERS
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to users table
CREATE TRIGGER trg_update_users
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Apply to user_services table
CREATE TRIGGER trg_update_user_services
  BEFORE UPDATE ON user_services
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- CHAT ROOM LAST MESSAGE TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION update_chat_room_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE chat_rooms
  SET 
    last_message = NEW.content,
    last_message_at = NEW.created_at
  WHERE id = NEW.room_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_chat_room_on_new_message
  AFTER INSERT ON messages
  FOR EACH ROW
  EXECUTE FUNCTION update_chat_room_last_message();

-- ============================================
-- AUTO-CLEANUP OLD OTP SESSIONS
-- ============================================

CREATE OR REPLACE FUNCTION cleanup_expired_otp_sessions()
RETURNS void AS $$
BEGIN
  DELETE FROM otp_sessions 
  WHERE expires_at < NOW() OR used_at IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Function to get or create a chat room between two users
CREATE OR REPLACE FUNCTION get_or_create_chat_room(
  p_user1_id UUID,
  p_user2_id UUID
)
RETURNS UUID AS $$
DECLARE
  v_room_id UUID;
  v_min_user_id UUID;
  v_max_user_id UUID;
BEGIN
  -- Ensure consistent ordering (user1 < user2)
  IF p_user1_id < p_user2_id THEN
    v_min_user_id := p_user1_id;
    v_max_user_id := p_user2_id;
  ELSE
    v_min_user_id := p_user2_id;
    v_max_user_id := p_user1_id;
  END IF;
  
  -- Try to get existing room
  SELECT id INTO v_room_id
  FROM chat_rooms
  WHERE user1_id = v_min_user_id 
    AND user2_id = v_max_user_id;
  
  -- If room doesn't exist, create it
  IF v_room_id IS NULL THEN
    INSERT INTO chat_rooms (user1_id, user2_id)
    VALUES (v_min_user_id, v_max_user_id)
    RETURNING id INTO v_room_id;
  END IF;
  
  RETURN v_room_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VIEWS FOR EASIER QUERYING
-- ============================================

-- View: service_providers with location info
CREATE OR REPLACE VIEW service_providers AS
SELECT 
  u.id AS user_id,
  u.phone,
  u.full_name,
  c.name_ar AS city_name,
  c.id AS city_id,
  ca.area_name AS area_name,
  ca.id AS area_id,
  u.avatar_url,
  u.bio,
  u.is_active AS user_active,
  u.created_at AS user_created_at,
  
  us.id AS user_service_id,
  us.service_id,
  s.name_ar AS service_name,
  s.name_en AS service_name_en,
  sc.name_ar AS category_name,
  sc.id AS category_id,
  us.description AS service_description,
  us.experience_years,
  us.hourly_rate,
  us.is_available,
  us.created_at AS service_created_at

FROM users u
JOIN user_services us ON u.id = us.user_id
JOIN services s ON us.service_id = s.id
JOIN service_categories sc ON s.category_id = sc.id
LEFT JOIN cities c ON u.city_id = c.id
LEFT JOIN city_areas ca ON u.area_id = ca.id

WHERE u.is_active = TRUE 
  AND us.is_available = TRUE
  AND s.is_active = TRUE
  AND sc.is_active = TRUE;

-- View: user_service_summary
CREATE OR REPLACE VIEW user_service_summary AS
SELECT 
  u.id AS user_id,
  u.full_name,
  u.phone,
  c.name_ar AS city_name,
  ca.area_name,
  u.avatar_url,
  COUNT(us.id) AS total_services,
  json_agg(
    json_build_object(
      'service_id', s.id,
      'service_name', s.name_ar,
      'category', sc.name_ar,
      'hourly_rate', us.hourly_rate,
      'is_available', us.is_available
    ) ORDER BY sc.display_order, s.name_ar
  ) FILTER (WHERE us.id IS NOT NULL) AS services

FROM users u
LEFT JOIN user_services us ON u.id = us.user_id
LEFT JOIN services s ON us.service_id = s.id
LEFT JOIN service_categories sc ON s.category_id = sc.id
LEFT JOIN cities c ON u.city_id = c.id
LEFT JOIN city_areas ca ON u.area_id = ca.id

WHERE u.is_active = TRUE
GROUP BY u.id, u.full_name, u.phone, c.name_ar, ca.area_name, u.avatar_url;

-- View: city_service_stats
CREATE OR REPLACE VIEW city_service_stats AS
SELECT 
  c.name_ar AS city,
  s.name_ar AS service_name,
  sc.name_ar AS category,
  COUNT(DISTINCT u.id) AS provider_count,
  AVG(us.hourly_rate) AS avg_hourly_rate

FROM users u
JOIN user_services us ON u.id = us.user_id
JOIN services s ON us.service_id = s.id
JOIN service_categories sc ON s.category_id = sc.id
LEFT JOIN cities c ON u.city_id = c.id

WHERE u.is_active = TRUE 
  AND us.is_available = TRUE
  AND s.is_active = TRUE

GROUP BY c.name_ar, s.name_ar, sc.name_ar
ORDER BY c.name_ar, provider_count DESC;
