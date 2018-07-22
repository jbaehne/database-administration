--quick look at who the super users are 
select 
   usesysid
  ,usename
  ,usesuper
  ,nvl(groname,'default') as group_name
from pg_user u
left join pg_group g 
  on ','||array_to_string(grolist,',')||',' like '%,'||cast(usesysid as varchar(10))||',%'
order by 
   nvl(groname,'default')
  ,usesuper
  ,usename;

--indepth view of privs by table by group
SELECT *
FROM information_schema.table_privileges;


-----------------// look at user's specific privs. \\-------------------------

SELECT
    u.usename,
    s.schemaname,
    has_schema_privilege(u.usename,s.schemaname,'create') AS user_has_select_permission,
    has_schema_privilege(u.usename,s.schemaname,'usage') AS user_has_usage_permission
FROM pg_user u
CROSS JOIN
    (
        SELECT DISTINCT schemaname 
        FROM pg_tables
    ) s
WHERE u.usename = 'myUserName'
  AND s.schemaname = 'mySchemaName';

---quick view of the privs by table by user
SELECT
    u.usename,
    t.schemaname||'.'||t.tablename,
    has_table_privilege(u.usename,t.tablename,'select') AS user_has_select_permission,
    has_table_privilege(u.usename,t.tablename,'insert') AS user_has_insert_permission,
    has_table_privilege(u.usename,t.tablename,'update') AS user_has_update_permission,
    has_table_privilege(u.usename,t.tablename,'delete') AS user_has_delete_permission,
    has_table_privilege(u.usename,t.tablename,'references') AS user_has_references_permission
FROM pg_user         u
CROSS JOIN pg_tables t
WHERE u.usename = 'myUserName'
  AND t.tablename = 'myTableName';