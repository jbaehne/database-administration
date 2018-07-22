--select view definition from the system db
select pg_get_viewdef('etl.v_generate_tbl_ddl', true);