-- 모든 사용자 계정 정보를 조회 하는 쿼리(SQL문)를 작성하세요
SELECT *
FROM all_users; -- CTRL + ENTER
-- FROM 대상 (테이블 또는 뷰);

-- 일반 사용자 계정 생성
-- ( scott / tiger )
-- DDL CREATE user문
CREATE USER scott IDENTIFIED BY tiger;
-- 오라클 주석 처리
-- 상태: 실패 - 테스트 실패: ORA-01045:
-- user SCOTT lacks CREATE SESSION privilege; logon denied
-- SYS → SCOTT CREATE SESSION 권한 부여
-- DCL : GRANT문 권한을 부여

-- 하나의 롤이 SYSTEM 권한이나 OBJEC_foles 뷰 권한을 포함할 수 있다
-- 미리 정의된 롤 확인 : dba
SELECT * 
FROM dba_roles;
-- 미리 정의된 롤에 부여된 권한을 확인 : DBA_SYS_PRIVS 뷰
SELECT *
FROM dba_sys_privs;

GRANT ??,??,?? TO Scott;