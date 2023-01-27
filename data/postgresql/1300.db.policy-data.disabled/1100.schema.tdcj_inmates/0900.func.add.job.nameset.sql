/*

 */
-- create or replace function add_job_name_set(job_size integer, d varchar(1024)) RETURNS integer AS
-- $$
-- declare
--     name_set_id integer;
-- begin
--     insert into identify_inmates_name_set(description) values (d);
--
--     select currval('identify_inmate_name_set_seq') into name_set_id;
--
--     for ln in select list_name from last_names loop
--         for fn in select first_name from first_names loop
--             insert into identify_inmate_names(last_name, first_name, name_set) values(ln, fn, id);
--         end loop;
--     end loop;
--     return name_set_id;
-- end
-- $$ LANGUAGE plpgsql;
