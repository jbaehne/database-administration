WITH cte_usage AS 
    (
        select obj.value:objectName::string objName
           -- , col.value:columnName::string  colName
            , count(*)                      uses
            , min(query_start_time)         since
            , max(query_start_time)         until
        from snowflake.account_usage.access_history 
            , table(flatten(direct_objects_accessed)) obj
            , table(flatten(obj.value:columns)) col
        WHERE user_name NOT IN ('SVC_FIVETRAN','ETL_DATABRICKS','INGEST_SF'
                                , 'INGEST_SF_UAT','INGEST_SF_DEV')
        group by 1
        order by uses desc
    )
SELECT *
FROM cte_usage
WHERE until <= CURRENT_DATE() - 90;