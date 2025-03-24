-- HR --
SELECT *
--FROM scott.emp;
FROM arirang;
--ORA-00942: table or view does not exist
--이유 ? hr 계정은 scott.emp 을 SELECT 권한이 X
-- 해결 ? scott 소유자 hr 계정에게 SELECT 할 수 있는 권한 부여...