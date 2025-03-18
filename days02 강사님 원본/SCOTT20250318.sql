--  [SCOTT] 
SELECT *
FROM user_users;
FROM dba_users;
FROM all_users;
-- 
SELECT *
FROM tabs;  -- user_tables의 약어
FROM user_tables;
-- dept, emp, bonus, salgrade 
SELECT *
FROM dept;
-- 테이블 구조
DESC dept;

-- 20250318 ~  SCOTT 소유로  insa.sql 테이블 생성.
-- insa 테이블의 구조 확인
DESCRIBE insa;
DESC insa;
-- SELECT 문 7개의 절 있다. --
WITH   -- 1
SELECT      -- 6
FROM   -- 2
WHERE  -- 3
GROUP BY -- 4
HAVING   -- 5
ORDER BY    -- 7
-- emp 테이블의 구조 확인 후 모든 사원 정보를 조회 . 
DESC emp;
SELECT *  -- emp 테이블의 모든 컬럼.
FROM scott.emp;

-- emp 테이블에서 사원번호, 사원명, 입사일자 조회
SELECT empno, ename, hiredate
FROM emp;

-- 권한 부여
GRANT 
     CONNECT,RESOURCE   -- 롤(role)
    ,UNLIMITED TABLESPACE  -- 권한
    TO SCOTT IDENTIFIED BY tiger;
-- 사용자 계정 수정
ALTER USER SCOTT DEFAULT TABLESPACE USERS;
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;

-- emp 테이블에서 사원번호, 사원명, 입사일자  조회
SELECT e.*, empno, ename, hiredate
FROM emp e;  -- emp 테이블의 Alias(별칭)
47행, 9열에서 오류 발생
ORA-00923: FROM keyword not found where expected
-- emp 테이블에서 잡(job) 컬럼만 조회.
-- emp 테이블에서 잡(job)의 종류만 조회 ( 중복된 잡은 제거 )
SELECT DISTINCTf job
FROM emp;
-- ( 주의할 점 )
SELECT DISTINCT ename, job
FROM emp;
--
SELECT ALL ename, job
FROM emp;
-- emp 테이블의 사원수 조회 : COUNT() 함수
SELECT COUNT(*) 총사원수
FROM emp;
-- [문제] emp 테이블에서 사원들의 잡의 종류 조회.~
SELECT COUNT( DISTINCT job )
FROM emp;
-- emp 테이블의 사원번호, 사원명, 입사일자 조회
--               YY/MM/DD
--       날짜형식 RR/MM/DD    ( YY/RR의 날짜 형식 차이점 파악 )
-- 7369	SMITH	'07/12/17'
SELECT empno, ename, hiredate
FROM emp;

-- emp 테이블에서 모든 사원의 월급을 조회.
-- comm 이 null 사원이 있다보니 pay 계산하니 결과값  null
-- (해결) 일단은 null 값은  0으로 처리...( 널처리 )
--      NULL 처리하는 오라클 함수 ?   3:01 수업시작~
DESC emp;
SELECT empno, ename
      , sal
--      , comm
      , NVL( comm, 0 ) comm
      , sal + NVL( comm, 0 ) pay
      , NVL( sal+comm, sal ) pay
      , sal + NVL2(comm,comm, 0) pay
      , NVL2(comm, sal+comm, sal) pay
FROM emp;

-- [문제] emp 테이블에서 사원번호, 사원명, 직속상사 조회
--    직속상사 null  사원의 mgr을 'CEO'라고 출력.
--   (해결)  NULL 처리하는 코딩.  NVL() 함수
--          mgr   NUMBER(4) -> 문자열 변환
-- Java :  int i = 10;   ->  "10"    10+""
-- Oracle : mgr || ''  ,   함수
--        숫자 -> 문자열 변환 : TO_CHAR()
--        날짜 -> 문자열 변환 : TO_CHAR()
SELECT empno, ename
      , mgr 
      , mgr || ''      
      , NVL( mgr || '', 'CEO')
      , TO_CHAR( mgr )
      , NVL( TO_CHAR( mgr ), 'CEO')
--      , NVL(mgr, 'CEO')
--      , NVL(mgr, 0)
FROM emp;
-- ORA-01722: invalid number
DESC emp;
-- MGR               NUMBER(4)

-- emp 테이블에서    ->  이름은 'SMITH'이고, 잡은 CLERK입니다.
-- Java  :  System.out.printf("이름은 \"%s\"이고, 잡은 %s입니다.", name, job);
SELECT '이름은 ' || CHR(39) || ename || '''이고, 잡은 ' || job || '입니다.'
FROM emp;

--SELECT 39, CHR(39)
--FROM emp;

-- [문제] emp 테이블에서 10번 부서 사원의 부서번호, 사원명, 입사일자 조회.
SELECT deptno, ename, hiredate
FROM emp
WHERE deptno = 10;  -- 오라클 연산자  같다/다르다    조건절
-- ORA-00936: missing expression
-- 자바
--for( int i=0; i<12; i++){
--     if( emps[i].deptno == 10 ){
--         syso(부서번호, 사원명, 입사일자)
--     }
--}
-- [문제] emp 테이블에서 10번 부서가 아닌 사원의 부서번호, 사원명, 입사일자 조회.
SELECT deptno, ename, hiredate
FROM emp
WHERE NOT deptno IN (20, 30, 40);
WHERE deptno NOT IN (20, 30, 40);
WHERE deptno IN (20, 30, 40);
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
WHERE deptno != 10;  -- 비교연산자 !=
WHERE NOT deptno = 10; -- NOT 논리연산자.
-- Oracle   논리연산자 
-- Java : WHERE deptno == 20 || deptno == 30 || deptno == 40;
WHERE deptno ^= 10;
WHERE deptno <> 10;
WHERE deptno != 10;
-- DEPT 부서테이블에 부서번호 확인
SELECT *
FROM dept;

-- [문제] insa 테이블에서 출신지역이 "수도권"인 사원수을 조회.
--    city 컬럼 : 서울, 경기, 인천
-- SELECT COUNT(*)
SELECT *
FROM insa
WHERE city IN ('서울','경기','인천');
WHERE city = '서울' OR city = '경기' OR city = '인천';
-- [문제] insa 테이블에서 비수도권 사원 정보 조회.
SELECT *
FROM insa
WHERE city NOT IN ('서울','경기','인천');
WHERE  city != '서울' AND city != '경기' AND city != '인천' ;
WHERE NOT ( city = '서울' OR city = '경기' OR city = '인천' );

-- (기억)
-- [문제] emp 테이블에서 사원명이  'ford' 인 사원의 모든 사원정보를 출력(조회)
-- Java : String.toUpperCase();
SELECT *
FROM emp
WHERE ename = UPPER(:ename);  -- LOWER()
-- 5:05 수업 시작~! 
SELECT ename
    , LOWER( ename )
    , UPPER( ename )
    , INITCAP( ename )
FROM emp;

-- ( 기억 ) is null , is not null   SQL 연산자 사용.
-- [문제] emp 테이블에서 comm 이 null 인 사원 정보 조회..
SELECT * 
FROM emp
WHERE comm IS NOT NULL;
WHERE comm IS NULL;
-- WHERE comm = null;

-- ( 기억 )
-- [문제] emp 테이블에서 월급(pay=sal+comm)이
--        2000 이상  4000 이하를 받는 사원 정보 조회
--        ( 부서번호, 사원명, 잡, 월급 )
SELECT deptno, ename ,  sal + NVL(comm, 0)  pay
FROM emp 
WHERE pay >= 2000 AND pay <= 4000;
-- ORA-00904: "PAY": invalid identifier  
-- [1]
SELECT deptno, ename ,  sal + NVL(comm, 0)  pay
FROM emp 
WHERE sal + NVL(comm, 0) >= 2000 AND sal + NVL(comm, 0) <= 4000;
-- [2]
SELECT deptno, ename ,  sal + NVL(comm, 0)  pay
FROM emp 
WHERE sal + NVL(comm, 0)  BETWEEN 2000 AND 4000;
WHERE sal + NVL(comm, 0) >= 2000 AND sal + NVL(comm, 0) <= 4000;
-- [3] WITH 절 사용
WITH emp_pay AS (
    SELECT deptno, ename ,  sal + NVL(comm, 0)  pay
    FROM emp 
)
SELECT *
FROM emp_pay
WHERE pay  BETWEEN 2000 AND 4000;

-- [4] 인라인뷰( inline view ) 사용
-- FROM ( subquery ) 별칭(alias)  인라인뷰
-- SELECT temp.*
SELECT *
FROM (
        SELECT deptno, ename ,  sal + NVL(comm, 0)  pay
        FROM emp        
     ) temp
WHERE pay  BETWEEN 2000 AND 4000;










