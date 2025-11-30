-- Allow anon to use the schema itself
GRANT USAGE ON SCHEMA public TO anon;

-- All tables: read, insert, update, delete
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public
TO anon;

-- Sequences (for serial/identity columns)
GRANT USAGE, SELECT, UPDATE
ON ALL SEQUENCES IN SCHEMA public
TO anon;

-- (Optional) functions, if you need them
GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public
TO anon;


-- For future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLES
TO anon;

-- For future sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT, UPDATE
ON SEQUENCES
TO anon;




-- Allow anon to use the schema
GRANT USAGE ON SCHEMA public TO anon;

-- Allow anon to work with the table
GRANT SELECT, INSERT, UPDATE, DELETE ON public.otp_sessions TO anon;

-- If the table has serial/identity columns, allow anon to use the sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;
