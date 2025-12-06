-- database/database_setup.sql
-- ============================================
-- WARSHASY DATABASE SETUP & SEED DATA

INSERT INTO cities (name_ar, name_en, display_order) VALUES
('دمشق', 'Damascus', 1),
('حلب', 'Aleppo', 2),
('حمص', 'Homs', 3),
('اللاذقية', 'Latakia', 4),
('حماة', 'Hama', 5),
('طرطوس', 'Tartus', 6),
('إدلب', 'Idlib', 7),
('الرقة', 'Raqqa', 8),
('دير الزور', 'Deir ez-Zor', 9),
('الحسكة', 'Al-Hasakah', 10),
('القامشلي', 'Qamishli', 11),
('درعا', 'Daraa', 12),
('السويداء', 'As-Suwayda', 13);

-- ============================================
-- SEED DATA - CITY AREAS (Damascus example)
-- ============================================

INSERT INTO city_areas (city_id, area_name) VALUES
-- Damascus
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'المزة'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'المهاجرين'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'باب توما'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'القصاع'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'أبو رمانة'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'المالكي'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'كفرسوسة'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'دمر'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'برزة'),
((SELECT id FROM cities WHERE name_ar = 'دمشق'), 'جرمانا'),

-- Aleppo
((SELECT id FROM cities WHERE name_ar = 'حلب'), 'العزيزية'),
((SELECT id FROM cities WHERE name_ar = 'حلب'), 'الفرقان'),
((SELECT id FROM cities WHERE name_ar = 'حلب'), 'الحمدانية'),
((SELECT id FROM cities WHERE name_ar = 'حلب'), 'الشهباء'),
((SELECT id FROM cities WHERE name_ar = 'حلب'), 'السليمانية'),

-- Homs
((SELECT id FROM cities WHERE name_ar = 'حمص'), 'الوعر'),
((SELECT id FROM cities WHERE name_ar = 'حمص'), 'الخالدية'),
((SELECT id FROM cities WHERE name_ar = 'حمص'), 'الحميدية'),
((SELECT id FROM cities WHERE name_ar = 'حمص'), 'الإنشاءات'),

-- Latakia
((SELECT id FROM cities WHERE name_ar = 'اللاذقية'), 'الزراعة'),
((SELECT id FROM cities WHERE name_ar = 'اللاذقية'), 'الرمل الجنوبي'),
((SELECT id FROM cities WHERE name_ar = 'اللاذقية'), 'الطابيات');

-- ============================================
-- SEED DATA - SERVICE CATEGORIES
-- ============================================

INSERT INTO service_categories (name_ar, name_en, description, display_order) VALUES
('خدمات حرفية', 'Craft Services', 'خدمات الأعمال الحرفية والإنشائية', 1),
('خدمات تقنية', 'Technical Services', 'خدمات التكنولوجيا والأجهزة التقنية', 2),
('تنظيف وخدمات منزلية', 'Cleaning & Home Services', 'خدمات التنظيف والعناية بالمنزل', 3);

-- ============================================
-- SEED DATA - SERVICES
-- ============================================

-- Craft Services (خدمات حرفية)
INSERT INTO services (category_id, name_ar, name_en, description) VALUES
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'مياه وصرف صحي', 'Plumbing', 'إصلاح وتركيب أنظمة المياه والصرف الصحي'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'كهرباء عامة', 'Electrical Work', 'تركيب وصيانة الأنظمة الكهربائية'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'دهان وديكور', 'Painting & Decoration', 'دهان الجدران والديكورات الداخلية'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'نجارة خشب', 'Carpentry', 'صناعة وإصلاح الأثاث الخشبي'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'ألمنيوم وزجاج', 'Aluminum & Glass', 'تركيب النوافذ والأبواب الألومنيوم'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'حدادة ولحام', 'Blacksmithing & Welding', 'خدمات الحديد واللحام'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'بناء وترميم', 'Construction & Renovation', 'بناء وترميم المباني'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'جبصين وسقوف مستعارة', 'Plastering & False Ceilings', 'تركيب الجبصين والأسقف المستعارة'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'تركيب سيراميك وبلاط', 'Ceramic & Tile Installation', 'تركيب البلاط والسيراميك'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'رخام وحجر', 'Marble & Stone', 'تركيب الرخام والأحجار'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات حرفية'), 
 'تنجيد وصيانة أثاث', 'Upholstery & Furniture Repair', 'تنجيد وإصلاح الأثاث');

-- Technical Services (خدمات تقنية)
INSERT INTO services (category_id, name_ar, name_en, description) VALUES
((SELECT id FROM service_categories WHERE name_ar = 'خدمات تقنية'), 
 'تكييف وتبريد', 'Air Conditioning & Refrigeration', 'تركيب وصيانة أجهزة التكييف'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات تقنية'), 
 'طاقة شمسية', 'Solar Energy', 'تركيب وصيانة أنظمة الطاقة الشمسية'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات تقنية'), 
 'الكترونيات', 'Electronics', 'إصلاح الأجهزة الإلكترونية'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات تقنية'), 
 'انترنت وشبكات', 'Internet & Networks', 'تركيب وصيانة الشبكات'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات تقنية'), 
 'صيانة أجهزة كهربائية', 'Electrical Appliance Repair', 'إصلاح الأجهزة الكهربائية المنزلية'),
((SELECT id FROM service_categories WHERE name_ar = 'خدمات تقنية'), 
 'صيانة مصاعد', 'Elevator Maintenance', 'صيانة وإصلاح المصاعد');

-- Cleaning & Home Services (تنظيف وخدمات منزلية)
INSERT INTO services (category_id, name_ar, name_en, description) VALUES
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'تنظيف منازل', 'House Cleaning', 'تنظيف شامل للمنازل'),
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'تنظيف سجاد', 'Carpet Cleaning', 'تنظيف السجاد والموكيت'),
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'تنظيف خزانات مياه', 'Water Tank Cleaning', 'تنظيف وتعقيم خزانات المياه'),
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'تنظيف أسطح', 'Roof Cleaning', 'تنظيف الأسطح والشرفات'),
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'خدمات نقل وأثاث', 'Moving & Furniture Services', 'نقل الأثاث والبضائع'),
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'تنسيق حدائق', 'Landscaping', 'تنسيق وصيانة الحدائق'),
((SELECT id FROM service_categories WHERE name_ar = 'تنظيف وخدمات منزلية'), 
 'خدمات زراعية', 'Agricultural Services', 'خدمات زراعية متنوعة');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Verify all data was inserted
SELECT 'Cities' as table_name, COUNT(*) as count FROM cities
UNION ALL
SELECT 'City Areas', COUNT(*) FROM city_areas
UNION ALL
SELECT 'Service Categories', COUNT(*) FROM service_categories
UNION ALL
SELECT 'Services', COUNT(*) FROM services;

-- Show service breakdown by category
SELECT 
  sc.name_ar as category,
  COUNT(s.id) as service_count
FROM service_categories sc
LEFT JOIN services s ON sc.id = s.category_id
GROUP BY sc.name_ar, sc.display_order
ORDER BY sc.display_order;