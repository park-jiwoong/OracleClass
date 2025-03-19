-- SYS --
SELECT owner
FROM dba_tables
--FROM all_tables
WHERE table_name = UPPER('employees');