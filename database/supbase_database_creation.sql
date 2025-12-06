-- database/supabase_database_creation.sql
-- ============================================
-- WARSHASY DATABASE SCHEMA (Simplified)
-- ============================================
-- Every user can offer services (0 to many)
-- No user types - all users are equal
-- Guest browsing allowed, login required for contact

-- ENUM TYPES
-- ============================================
CREATE TYPE syrian_city AS ENUM (
  'دمشق', 'حلب', 'حمص', 'اللاذقية', 'حماة', 'الرقة',
  'دير الزور', 'الحسكة', 'القامشلي', 'درعا',
  'السويداء', 'طرطوس', 'إدلب'
);

CREATE TYPE service_category AS ENUM (
  'أعمال حرفية',
  'أعمال تقنية',
  'تنظيف وخدمات منزلية'
);

CREATE TYPE service_type AS ENUM (
  -- أعمال حرفية
  'سباكة', 'كهرباء عامة', 'دهان وديكور', 'نجارة خشب', 'ألمنيوم وزجاج', 'حدادة ولحام',
  'بناء وترميم', 'مياه وصرف صحي', 'جبصين وسقوف مستعارة', 'تركيب سيراميك وبلاط',
  'رخام وحجر', 'تنجيد وصيانة أثاث',
  -- أعمال تقنية
  'تكييف وتبريد', 'طاقة شمسية', 'الكترونيات', 'انترنت وشبكات', 'صيانة أجهزة كهربائية', 'صيانة مصاعد',
  -- تنظيف وخدمات منزلية
  'تنظيف منازل', 'تنظيف سجاد', 'تنظيف خزانات مياه', 'تنظيف أسطح', 'خدمات نقل وأثاث', 'تنسيق حدائق', 'أعمال زراعية'
);

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. SERVICES TABLE (Catalog of available services)
-- ============================================
CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  category service_category NOT NULL,
  service_name service_type NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. USERS TABLE (All users are equal)
-- ============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  city syrian_city,
  location TEXT,
  avatar_url TEXT,
  bio TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. USER SERVICES (Users can offer 0 to many services)
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
-- 4. CHAT ROOMS TABLE
-- ============================================
CREATE TABLE chat_rooms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  user2_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  last_message TEXT,
  last_message_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user1_id, user2_id),
  CHECK (user1_id < user2_id) -- Ensure consistent ordering
);

-- ============================================
-- 5. MESSAGES TABLE
-- ============================================
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  room_id UUID REFERENCES chat_rooms(id) ON DELETE CASCADE NOT NULL,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE otp_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone TEXT NOT NULL,
  otp_code TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (expires_at > created_at)
);

CREATE OR REPLACE FUNCTION cleanup_expired_otp_sessions()
RETURNS void AS $$
BEGIN
  DELETE FROM otp_sessions 
  WHERE expires_at < NOW() OR used_at IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

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
-- 7. CITY AREAS TABLE (Optional - for future area filtering)
-- ============================================
CREATE TABLE city_areas (
  id SERIAL PRIMARY KEY,
  city syrian_city NOT NULL,
  area_name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Users indexes
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_city ON users(city);
CREATE INDEX idx_users_location ON users(location);
CREATE INDEX idx_users_active ON users(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- User services indexes
CREATE INDEX idx_user_services_user ON user_services(user_id);
CREATE INDEX idx_user_services_service ON user_services(service_id);
CREATE INDEX idx_user_services_available ON user_services(is_available) WHERE is_available = TRUE;
CREATE INDEX idx_user_services_city_service ON user_services(service_id) 
  INCLUDE (user_id); -- For faster service searches

-- Combined index for service search by city
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

-- Auth index

CREATE INDEX idx_otp_sessions_phone ON otp_sessions(phone);
CREATE INDEX idx_otp_sessions_expires ON otp_sessions(expires_at);
CREATE INDEX idx_otp_sessions_unused
  ON otp_sessions(phone, otp_code)
  WHERE used_at IS NULL;

CREATE UNIQUE INDEX idx_device_sessions_user_device
  ON device_sessions(user_id, device_id);

CREATE UNIQUE INDEX idx_device_sessions_token
  ON device_sessions(session_token);

CREATE INDEX idx_device_sessions_user
  ON device_sessions(user_id);

CREATE INDEX idx_device_sessions_expires
  ON device_sessions(expires_at)
  WHERE expires_at IS NOT NULL;

-- City areas index
CREATE INDEX idx_city_areas_city ON city_areas(city);

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
  DELETE FROM auth_sessions 
  WHERE expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- Optional: Run cleanup periodically (can be set up via Supabase cron jobs)

-- ============================================
-- VIEWS FOR EASIER QUERYING
-- ============================================

-- =======================================================
-- VIEW: service_providers
-- Get all users offering a specific service with their details
-- =======================================================

CREATE OR REPLACE VIEW service_providers AS
SELECT 
  u.id AS user_id,
  u.phone,
  u.full_name,
  u.city,
  u.location,
  u.avatar_url,
  u.bio,
  u.is_active AS user_active,
  u.created_at AS user_created_at,
  
  us.id AS user_service_id,
  us.service_id,
  s.service_name,
  s.category AS service_category,
  us.description AS service_description,
  us.experience_years,
  us.hourly_rate,
  us.is_available,
  us.created_at AS service_created_at

FROM users u
JOIN user_services us ON u.id = us.user_id
JOIN services s ON us.service_id = s.id

WHERE u.is_active = TRUE 
  AND us.is_available = TRUE;

-- =======================================================
-- VIEW: user_service_summary
-- Get count of services per user
-- =======================================================

CREATE OR REPLACE VIEW user_service_summary AS
SELECT 
  u.id AS user_id,
  u.full_name,
  u.phone,
  u.city,
  u.location,
  u.avatar_url,
  COUNT(us.id) AS total_services,
  json_agg(
    json_build_object(
      'service_id', s.id,
      'service_name', s.service_name,
      'category', s.category,
      'hourly_rate', us.hourly_rate,
      'is_available', us.is_available
    ) ORDER BY s.category, s.service_name
  ) FILTER (WHERE us.id IS NOT NULL) AS services

FROM users u
LEFT JOIN user_services us ON u.id = us.user_id
LEFT JOIN services s ON us.service_id = s.id

WHERE u.is_active = TRUE
GROUP BY u.id, u.full_name, u.phone, u.city, u.location, u.avatar_url;

-- =======================================================
-- VIEW: city_service_stats
-- Statistics of service providers per city
-- =======================================================

CREATE OR REPLACE VIEW city_service_stats AS
SELECT 
  u.city,
  s.service_name,
  s.category,
  COUNT(DISTINCT u.id) AS provider_count,
  AVG(us.hourly_rate) AS avg_hourly_rate

FROM users u
JOIN user_services us ON u.id = us.user_id
JOIN services s ON us.service_id = s.id

WHERE u.is_active = TRUE 
  AND us.is_available = TRUE

GROUP BY u.city, s.service_name, s.category
ORDER BY u.city, provider_count DESC;

-- =======================================================
-- VIEW: chat_overview
-- Chat rooms with participant details
-- =======================================================

CREATE OR REPLACE VIEW chat_overview AS
SELECT 
  cr.id AS room_id,
  cr.last_message,
  cr.last_message_at,
  cr.created_at AS room_created_at,
  
  u1.id AS user1_id,
  u1.full_name AS user1_name,
  u1.avatar_url AS user1_avatar,
  
  u2.id AS user2_id,
  u2.full_name AS user2_name,
  u2.avatar_url AS user2_avatar,
  
  (SELECT COUNT(*) 
   FROM messages m 
   WHERE m.room_id = cr.id 
     AND m.is_read = FALSE) AS unread_count

FROM chat_rooms cr
JOIN users u1 ON cr.user1_id = u1.id
JOIN users u2 ON cr.user2_id = u2.id

ORDER BY cr.last_message_at DESC NULLS LAST;

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
