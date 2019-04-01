/*
Title: User Privs sampler
Description: This is like a db privs deep dive, bunch of different views of the user privs
*/

--quick look at who the super users are
select 
   usesysid
  ,usename
  ,usesuper
  ,nvl(groname
  ,'default') as group_name
from pg_user u
left join pg_group g 
  on ','||array_to_string(grolist,',')||',' like '%,'||cast(usesysid as varchar(10))||',%'
order by 
   nvl(groname,'default')
  ,usesuper
  ,usename;

--indepth view of privs by table by group
SELECT *
FROM information_schema.table_privileges
WHERE table_schema = 'etl'
AND table_name = 'test_monkey_butt';

-------Schmea ACL
select
    nspname                      as schemaname
  , array_to_string(nspacl, ',') as acls
from
    pg_namespace
where
    nspacl is not null
and nspowner != 1
and array_to_string(nspacl, ',') like '%u_A=%' -- REPLACE USERNAME
;

-----------TABLE ACL
select
    pg_namespace.nspname as schemaname
  , pg_class.relname as tablename
  , array_to_string(pg_class.relacl, ',') as acls
from pg_class
left join pg_namespace on pg_class.relnamespace = pg_namespace.oid
where
    pg_class.relacl is not null
and pg_namespace.nspname not in (
    'pg_catalog'
  , 'pg_toast'
  , 'information_schema'
)
and array_to_string(pg_class.relacl, ',') like '%u_A=%' -- REPLACE USERNAME
order by
    pg_namespace.nspname
  , pg_class.relname
;

-----default acl
select pg_get_userbyid(d.defacluser) as user,
n.nspname as schema,
case d.defaclobjtype when 'r' then 'tables' when 'f' then 'functions' end
as object_type,
array_to_string(d.defaclacl, ' + ')  as default_privileges
from pg_catalog.pg_default_acl d
left join pg_catalog.pg_namespace n on n.oid = d.defaclnamespace;