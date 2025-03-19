-- SCOTT --
SELECT firt_name, last_name
FROM employees;
-- SCOTT 소유하고 있는 모든 테이블 정보 조회
SELECT *
FROm user_tables
WHERE table_name = UPPER('employees');
-- employees 테이블은 누구 OWNER인가?
SELECT 65, CHR(65)
FROM dual;
-- 직속상사가 없는 사원의 mgr 컬럼값을 'CEO' 출력
SELECT enpno ,ename, mgr
--       ,NVL(mgr, 'CEO')
--       ,NVL(mgr, 0)
        ,NVL(mgr || '', 'CEO')  -- 문자열 100+""
        ,TO_CHAR(mgr)           -- 문자열로 변환 시켜주는 함수
FROM emp;

DESC emp;

--SELECT buseo
SELECT DISTINCT buseo
FROM insa;
--ORA-00904: "PAY": invalid identifier
SELECT emp.*, sal + NVL(comm, 0) pay
FROM emp
--WHERE pay >= 1000 AND pay <= 3000;
WHERE sal + NVL(comm, 0) >= 1000 AND sal + NVL(comm, 0) <= 3000 AND deptno != 30;

-- [2] inline view 사용
SELECT * 
FROM( SELECT emp.*
        , sal + NVL(comm, 0)pay
        FROM emp
        WHERE deptno != 10
    ) t
WHERE t.pay BETWEEN 1000 AND 3000;

--[3] WITH 절 사용
WITH ?? AS (
    SELECT emp.*
        , sal + NVL(comm, 0)pay
        FROM emp
        WHERE deptno != 30
        )
SELECT *
FROM temp
WHERE pay BETWEEN 1000 AND 3000;

SELECT *
FROM emp
WHERE mgr IS NULL;
--
SELECT *
FROM insa
WHERE tel IS NULL;
--
DESC emp;
SELECT insa.*
        ,NVL(tel,'연락처 등록 안됨')
FROM insa
WHERE tel IS NULL;
-- (기억) ORA-00937: not a single-group group function
SELECT insa.*
--    ,COUNT(*)
FROM insa
WHERE buseo = '개발부';
-- ,if(tel is mull) X       PL/SQL
-- else             O
    ,NVL2(tel,'O','X')

SELECT COUNT(*)
FROM insa
WHERE buseo = '개발부';
-- 복습 풀이, 0319 ~

-- [문제] SELECT문 연습
-- WHERE 조건절 문
-- ORDER BY 조건전 문       ASC/DESC
-- insa 테이블에서 출생년도가 70년대생인 사원 정보를 조회.

--[1] LIKE 연산자 사용
SELECT num, name, ssn
FROM insa
WHERE ssn LIKE '7_____-_______'
--WHERE ssn like '7%'; -- 조건절
ORDER BY ssn ASC;
-- [문제] insa 테이블에서 사원의 성이 김씨인 사원 조회.
SELECT num, name
FROM insa
WHERE REGEXP_LIKE(name, '김');
WHERE name LIKE '_김_'; 
WHERE name LIKE '_김%'; 
WHERE name LIKE '김_'; 
WHERE name LIKE '김__'; 
WHERE name LIKE '%김%'; -- 위치에 상관없이 '김'이라는 문자를 포함하고 있는가? 
WHERE name LIKE '%김'; -- 이름의 맨 마지막 문자는 '김'
WHERE name LIKE '김%'; -- 이름의 맨 처음 문자는 '김'
--WHERE; -- SUBSTR(), INSTR()


--[2] SUBSTR
SELECT num, name, ssn
    ,SUBSTR(ssn, 1, 1)  -- '7'
    ,SUBSTR(ssn, 0, 1)
    ,SUBSTR(ssn, -1, 1)
    ,SUBSTR(ssn, -7)
FROM insa
-- WHERE 70년대생 조건절;
--WHERE SUBSTR(ssn,0,1) = '-7'
WHERE SUBSTR(ssn,0,1) = '7'
ORDER BY ssn ASC;

--[3] INSTR
SELECT num, name, ssn
        FROM insa
        WHERE INSTR(ssn, 7) = 1;

--1001	홍길동	771212-1******
--1003	이순애	770922-2******
--1004	김정훈	790304-1******
--1006	이기자	780505-2******


SELECT name
--        ,ssn rrn
--        ,SUBSTR(ssn, 1, 8)
--        ,CONCAT(SUBSTR(ssn, 1, 8), '******') rrn
--        ,RPAD() / LPAD() 함수 [][][][] [][][][] [][][][] [][][][]
--        ,RPAD(SUBSTR(ssn, 1, 8) 14,'*') rrn
--        ,REPLACE() 함수
--        ,REPLACE (ssn, SUBSTR(ssn, -6), '******') rrn
          REGEXP_REPLACE() 함수   ← 여기 서 부터 시작
          
          
FROM insa;
--
SELECT * FROM dept;
--deptno    dname       loc
--10	ACCOUNTING	NEW YORK
--20	RESEARCH	DALLAS
--30	SALES	CHICAGO
--40	OPERATIONS	BOSTON
SELECT dname
            , REPLACE(dname, 'E') -- 삭제
            , REPLACE(dname, 'E', '[이]') -- 교체
FROM dept;


-- RPAD() / LPAD() 함수 사용 예
SELECT ename, sal
            ,RPAD(sal, 10, '*')
            ,LPAD(sal, 10, '#')
FROM emp;

SELECT *
FROM tbl_test;
-- REGEXP REPLACE () 함수 테스트
select regexp_replace(email,'http://([^/]+).*', '\1')
from TEL_TABLE;
--
SELECT email
    ,REGEXP_REPLACE (email, 'arirang', 'seoul')
FROM tbl_test;
--
SELECT 'hello hi hello hi hello'
      ,REGEXP_REPLACE('hello hi hello hi hello', 'Hello','헬로우', 1,0, 'i')
--    ,REGEXP_REPLACE('hello hi hello hi hello', 'hello','헬로우', 1, 1 )
--     첫 번째 hello 만을 '헬로우' 교체.
--    ,REGEXP_REPLACE('hello hi hello hi hello', 'hello','헬로우', 1, 1 )
--    ,REGEXP_REPLACE('hello hi hello hi hello', 'hello','헬로우', 6, 1 )
--    ,REGEXP_REPLACE('hello hi hello hi hello', 'hello','헬로우', 1, 2 )
FROM dual;
-- 문자열에서 숫자는 제거
SELECT REGEXP_REPLACE('hello 123 hello 3453 hello', 'd+','')
FROM dual;
--
SELECT REGEXP_REPLACE('LEE CHANG IK', '(.*)(.*)(.*)','\3\2\1')
FROM dual;

SELECT name, ssn
--      , REGEXP_REPLACE()
        , REGEXP_REPLACE(ssn, '\d{6}-\d)\d{6}', '1\******')
FROM insa;
-- 주민등록 번호로 부터  년/월/일 출력.
SELECT name, ssn
        ,SUBSTR(ssn, 1, 2) as "year"
        ,SUBSTR(ssn, 3, 2) month
        ,SUBSTR(ssn, 5, 2) "DATE" -- 예약어
        ,SUBSTR(ssn, 1, 6) "DATE" -- '771212' →  날짜 자료형 변환 DATE
        ,TO_DATE (SUBSTR(ssn, 1, 6))
FROM insa;

SELECT * FROM v$version;

-- 오늘 날짜 정보를 조회. SYSDATE 함수
-- '25/03/19'
SELECT SYSDATE
    ,TO_CHAR(SYSDATE, 'YYYY') y
--    ,TO_CHAR(SYSDATE, 'YEAR')
    ,TO_CHAR(SYSDATE, 'MM') m -- '03'
--    ,TO_CHAR(SYSDATE, 'MONTH')-- '3월'
--    ,TO_CHAR(SYSDATE, 'MON')-- '3월'
    ,TO_CHAR(SYSDATE, 'DD') d
        ,TO_CHAR(SYSDATE, 'DAY')
FROM dual;

-- 오늘 [문제] 70년대 생 사원 정보 조회
SELECT *
FROM( --인라인뷰
    SELECT name, ssn
    ,TO_CHAR(   TO_DATE (SUBSTR (ssn, 1, 6)), 'YY') yy
    FROM insa
)  t
WHERE yy BETWEEN 70 AND 79;
--
DESC emp;
SELECT ename, hiredate
, TO_CHAR(hiredate, 'YYYY') y
, TO_CHAR(hiredate, 'MM') m
, TO_CHAR(hiredate, 'DD') d
--    EXTRACT() 추출하다
    EXTRACT(YEAR FROM hiredate) y2 
    EXTRACT(MONTH FROM hiredate) m2
    EXTRACT(DAY FROM hiredate) d2
FROM emp;

--
SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dept;

