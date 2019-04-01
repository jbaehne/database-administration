/*-------------------------------------------------------------------------------------
Title: List User Permissions
Decription: This lists out all of the DB objects and the permission set for each object
-------------------------------------------------------------------------------------*/

SELECT * 
FROM 
    (
    SELECT 
         schemaname
        ,objectname
        ,usename
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'select') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS sel
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'insert') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS ins
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'update') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS upd
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'delete') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS del
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'references') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS ref
    FROM
        (
        SELECT schemaname, 't' AS obj_type, tablename AS objectname, schemaname + '.' + tablename AS fullobj FROM pg_tables
        WHERE schemaname not in ('pg_internal')
        UNION
        SELECT schemaname, 'v' AS obj_type, viewname AS objectname, schemaname + '.' + viewname AS fullobj FROM pg_views
        WHERE schemaname not in ('pg_internal')
        ) AS objs
        ,(SELECT * FROM pg_user) AS usrs
    ORDER BY fullobj
    )
WHERE (sel = true or ins = true or upd = true or del = true or ref = true)
ORDER BY usename;
