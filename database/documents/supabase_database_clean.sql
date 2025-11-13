do $$
declare
  r record;
begin
  for r in
    select tablename
    from pg_tables
    where schemaname = 'public'
  loop
    execute format('drop table if exists public.%I cascade;', r.tablename);
  end loop;
end$$;