--  [SYS] 
SELECT *
--FROM user_users;
FROM dba_users;
FROM all_users;
-- CTRL + /
SELECT *
FROM dba_data_files;
FROM dba_tablespaces;

-- HR 계정이 유무 확인. / SCOTT 계정 샘플 ..
SELECT *
FROM all_users;
-- HR 계정의 비밀번호를 새로 설정( lion )
-- DDL : CREATE, ALTER, DROP
--      CREATE USER
--      ALTER USER
ALTER USER hr IDENTIFIED BY lion;
-- ht 계정의 잠김 상태 확인 + 해제
ALTER USER hr ACCOUNT UNLOCK;
-- 
 ALTER USER hr IDENTIFIED BY lion 
               ACCOUNT UNLOCK;

--      DROP USER
SELECT *
FROM dba_sys_privs;
FROM dba_roles;
-- 20250318 ~ scott.sql  롤 부여.
-- 12:04 수업 시작 
SELECT *  
FROM scott.emp;  -- 시노님
FROM 스키마.emp;








