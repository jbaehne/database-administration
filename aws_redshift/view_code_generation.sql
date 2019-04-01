--select view definition from the system db
select pg_get_viewdef('your_view', true);
