SELECT 
  action_name as EVENT,
  CASE 
    WHEN request_params.full_name_arg IS NOT NULL THEN
      SUBSTRING_INDEX(request_params.full_name_arg, '.', 1)
    WHEN action_name IN ('createTable', 'commandSubmit') THEN 'NO_CATALOG'
    ELSE 'UNKNOWN'
  END as CATALOG,
  CASE 
    WHEN request_params.full_name_arg IS NOT NULL THEN
      SUBSTRING_INDEX(SUBSTRING_INDEX(request_params.full_name_arg, '.', 2), '.', -1)
    WHEN action_name IN ('createTable', 'commandSubmit') THEN 'NO_SCHEMA'
    ELSE 'UNKNOWN'
  END as SCHEMA,
  COUNT(*) as ACTION_COUNT
FROM system.access.audit
WHERE action_name IN (
  'createTable',
  'commandSubmit',
  'getTable',
  'deleteTable'
)
AND datediff(now(), event_date) < 90
AND (request_params.full_name_arg IS NOT NULL OR action_name IN ('createTable', 'commandSubmit'))
GROUP BY 1, 2, 3
ORDER BY CATALOG, SCHEMA, EVENT, ACTION_COUNT DESC;