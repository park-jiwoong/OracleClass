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

------------ 2025 03 20 (목) ------------
--[1]DESC dept;
SELECT ssn,
    SUBSTR(ssn, 1, 2) YEAR,
    TO_CHAR(TO_DATE(SUBSTR(ssn, 1, 6)), 'MM') MONTH,
    TO_CHAR(TO_DATE(SUBSTR(ssn, 1, 6)), 'MON') MONTH,
    EXTRACT (MONTH FROM TO_DATE(SUBSTR(ssn, 1, 6) ))MONTH,
    EXTRACT (DAY FROM TO_DATE(SUBSTR(ssn, 1, 6) ))"DATE",
    SUBSTR(ssn, -7, 1) "GENDER"
FROM insa;

SELECT * FROM insa;
DESC insa;

--[2]
--(1)
SELECT name ssn FROM insa
WHERE
    SUBSTR(SSN, 1, 2) BETWEEN 70 AND 79  -- 70년대생 (70년부터 79년까지)
    AND SUBSTR(SSN, 3, 2) = 12           -- 12월생
ORDER BY ssn;
--(2)
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%' --% _
ORDER BY ssn ASC;
--(3)
SELECT name, ssn
FROM insa
--WHERE REGEXP_LIKE(ssn, '^[0-9]12') -- REGEXP_LIKE() 함수 사용
--WHERE REGEXP_LIKE(ssn, '^7.12') -- REGEXP_LIKE() 함수 사용
WHERE REGEXP_LIKE(ssn, '^7\d12') -- REGEXP_LIKE() 함수 사용

--[3]
-- LIKE 연산자
    SELECT * FROM insa
    --WHERE ssn LIKE '7%' AND ssn LIKE '%-1%';
    WHERE ssn LIKE '7%'
    AND (SUBSTR(ssn, 8, 1) = 1);

-- REGEXP_LIKE() 함수
SELECT * FROM insa 
WHERE REGEXP_LIKE(ssn, '^7[0-9]{6}[1]');
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]');
--WHERE REGEXP_LIKE(ssn, '^7\d{5}-');

--[4]
SELECT * FROM emp
WHERE REGEXP_LIKE (ename, 'la', 'i'); (기억)
WHERE REGEXP_LIKE(ename, 'la','i'); --REGEXP_LIKE() 함수
WHERE LOWER(ename) LIKE '%la%'
    OR ename LIKE '%La%'
    OR ename LIKE '%lA%'
    OR ename LIKE '%LA%';   -- LIKE 연산자

--[5]
select name, ssn, replace(replace(substr(ssn, 8, 1), '1', 'X'), '2', 'O') "GENDER"
from insa;

SELECT name, ssn
        ,SUBSTR(ssn, -7, 1) gender
--        if(g == 1) X
--        else
--        ,NVL2(REPLACE(ssn, 8, 1), '1', null), 'O', 'X') gender
        ,NULLIF(SUBSTR(ssm, 8,1)'1'), 'O', 'X') gender
--        CASE문, DECODE 문 사용 가능
FROM insa;

-- NULLIF() 함수 설명
SELECT NULLIF(1,1), NULLIF(1,2)
FROM dual;

--[6]
-- TO CHAR()함수
--(1)
SELECT name, ibsadate 
WHERE TO_CHAR(ibsadate,'YYYY') >= '2000'; -- 입사년도
EXTRACT(YEAR FROM ibsadate) -- 입사년도
FROM inas
WHERE EXTRACT (YEAR FROM ibsadate)

--EXTRACT() 함수
SELECT name, ibsadate FROM insa
WHERE EXTRACT(YEAR FROM ibsadate) >= 2000;

-- [7] SYSDATE 함수
-- 오라클 날짜 자료형 : DATE, TIMESTAMP
SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual;
-- SYSDATE  년, 월, 일     요일/시간/분/처 TO_CHAR() 함수 사용
--ⓐ
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY HH24:MI:SS') AS formatted_date
FROM dual;

--ⓑ (TO_CHAR 문자열로 반환)
SELECT
    TO_CHAR(SYSDATE, 'YYYY') AS year,
    TO_CHAR(SYSDATE, 'MM') AS month,
    TO_CHAR(SYSDATE, 'DD') AS day,
    TO_CHAR(SYSDATE, 'DAY') AS day_of_week,  -- 요일 (전체 이름, 예: MONDAY)
    TO_CHAR(SYSDATE, 'DY') AS day_of_week_short, -- 요일 (약어, 예: MON)
    TO_CHAR(SYSDATE, 'D') AS day_of_week_num,   -- 요일 (숫자, 1:일요일, 2:월요일, ..., 7:토요일)
    TO_CHAR(SYSDATE, 'HH24') AS hour_24,        -- 24시간 형식의 시간
    TO_CHAR(SYSDATE, 'HH') AS hour_12,          -- 12시간 형식의 시간
    TO_CHAR(SYSDATE, 'MI') AS minute,
    TO_CHAR(SYSDATE, 'SS') AS second
FROM dual;

--ⓒ (EXTARCT 특정 구성요소 연, 월, 일, 시, 분, 초 등)를 숫자 형태로 추출)
-- EXTRACT() 시간/분/초/요일 출력
SELECT
    EXTRACT(YEAR FROM SYSDATE) AS year,
    EXTRACT(MONTH FROM SYSDATE) AS month,
    EXTRACT(DAY FROM SYSDATE) as day,
    EXTRACT(HOUR FROM SYSTIMESTAMP) AS hour,
    EXTRACT(MINUTE FROM SYSTIMESTAMP) AS minute,
    EXTRACT(SECOND FROM SYSTIMESTAMP) AS second
FROM dual;

-- EXTRACT 
SELECT SYSDATE
        ,EXTRACT (HOUR FROM CAST (SYSDATE AS TIMESTAMP )) h
         ,EXTRACT (HOUR FROM CAST (SYSDATE AS TIMESTAMP )) m
         ,EXTRACT (HOUR FROM CAST (SYSDATE AS TIMESTAMP )) s
FROM dual;

SELECT SYSDATE
    ,TO_CHAR(SYSDATE 'DS', 'TS')
FROM dual;

--[8]
SELECT dname
FROM dept   -- 모든 레코드 삭제
WHERE deptno = 10;
--DML : UPDATE
UPDATE dept
SET dname = 'QC100';
WHERE deptno 10;
-- 검색 : 부서명에 '100' 포함된 부서정보를 조회... (LIKE 연산자 사용)
SELECT *
FROM dept
REGEXP_LIKE(dname, '100%');--REGEXP_LIKE 함수 사용
--WHERE dname LIKE '%\%%'ESCAPE '\' ;
--WHERE dname LIKE '%100\%%'ESCAPE '\';

ROLLBACK;

--[9] 풀이 .co.kr → .com
SELECT email
--        ,REPLACE(email, '.co.kr → .com'. '.com')
        ,ERGEXP_REPLACE(email,'(.+).co.kr$', '.com')  
FROM tbl_test;

--[10]
WITH temp AS (
        SELECT deptno, ename, sal + NVL(comm, 0) pay
        FROM em[
        )
SELECT deptno , e

--[11]
SELECT deptno
,ename || '(' || pay ||')' "ENAME (PAY)"
--REGEXP_REPLACE(ename||pay, '([A-Z])(\d+)', '\1(\2)')
, RPAD(' ', ROUND(pay/100)+1, '#') bar
FROM temp
ORDER BY deptno, pay DESC;

-- 2025 30 20 수업시작~
-- DML : INSERT, UPDATE, DELETE + TCL : COMMIT, ROLLBACK
--10	QC100	NEW YORK
--20	QC100	DALLAS
--30	QC100	CHICAGO
--40	QC100	BOSTON
SELECT *
FROM dept;
-- DML : INSERT
INSERT INTO 테이블명 (컬럼명...) VALUES (컬럼값,,,);
INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC', 'SEOUL'); 
-- 1행 삽입됨



INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC2', 'SEOUL');
INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC2', 'SEOUL');


DESC dept;
INSERT INTO dept (deptnpo, dname, loc) VALUES (100.'QC3', nill);
COMMIT;

SELECT
FROM
--DML : DELETE 문에 WHERE 절이 없으면 모든걸 삭제함
DELETE FROM 테이블명;
DELETE FROM dept
WHERE deptno >= 60;

--
DELETE FROM dept
WHERE deptno IN (10 20 50);
WHERE deptno >= 50;
--[문제]
SELECT *
FROM dept;
--  (기억)
DELETE FROM dept
WHERE dname LIKE '%' || UPPER ('qc') || '%';
COMMIT;

INSERT INTO dept VALUES (50, null.null);
COMMIT;

--예)

UPDATE dname, loc FROM dept WHERE deptno =40;
-- OPERATIONS BOSTON
-- [1]
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 40),
loc = (SELECT loc FROM dept WHERE deptno = 40)
WHERE deptno = 50;


--[2]
UPDATE dept
SET (dname, loc) = (SELECT dname FROM dept WHERE deptno = 40),
WHERE deptno = 50;

rollback;

delete from dept
where dept >= 50;
commit;

update dept set dname = 'ACCOUNTING', loc = 'NEW YORK' where deptno = 10;
update dept set dname = 'RESEARCH', loc = 'DALLAS' where deptno = 20;
update dept set dname = 'SALES', loc = 'CHICAGO' where deptno = 30;
update dept set dname = 'OPERATIONS', loc = 'BOSTON' where deptno = 40;
commit;
--[문제] 40번 부서의 부서명, 지역명을 얻어와서 50번 부서명, 지역명으로  UDATE 문을 작성하세요
update dept set dname = (select dname from dept where deptno = 40),
loc = (select loc from dept where deptno = 40) where deptno = 50;
-- 하드쿼리

UPDATE dept SET (dname, loc) = ( SELECT d.dname, d.loc FROM dept d WHERE d.deptno = 40 ) WHERE deptno = 50;
-- 서브쿼리
SELECT * FROM dept WHERE deptno IN (40, 50);

--[문제] emp 테이블에서 10번 부서원 급여 20% 인상, 20번 부서원 급여 15% 인상 그 외 부서원 급여 5% 인상을 시키는 쿼리를 작성
select deptno, ename, pay
,'20%',pay*0.2 "급여인상액"
,pay + (pay*0.2) "인상된 pay"
,pay * 1.2 "인상된 pay"
from(  )e;

-- sal 현재 sal 에서 급여 (pay) 
update emp
set sal = sal + ((sal+ nvl(comm,0)*0.1);
--WHERE

-- [오라클 연산자 (Operator)] --
1. 비교연산자 
2. 논리연산자
3. SQL연사자
4. NULL 연산자
5. SET (잡합)연산자
6. 산술 연산자



update emp
SET sal = sal * 1.20 where deptno = 10;

update emp
SEt sal = sal * 1.15 where deptno = 15;
--[문제] emp 테이블에서 모든 서원의 급여를 20% 인상 시키는 쿼리를 작성
-- ( 급여 (pay) = sal + comm )


--[산술 연산자] + - * /
SELECT 5+3
    ,5-3
    ,5*3
    ,5/3
FROM dual;
-- [스키마.daul]?
--scott 소유자가 hr 계정에게 SELECT 권한 부여....
GRANT SELECT ON emp TO hr;
--ORA-00903: invalid table name
--Grant을(를) 성공했습니다.
--1) 권환 회수
REVOKE OM SELECT ON emp FROM hr;
-- Revoke
--
SELECT SYSDATE, CURRENT_TINESTAMP
FROM dual;
-- + - *    /(기억1.6666)
-- ORA-00911: invalid character
-- 5/3 몫, 나머지 조회...
SELECT 
        -- 몫 1 오라클 절삭하는 함수 / 연산자    자바  절삭 Math.floor()
        FLOOR(5/3)          -- 절삭, 리턴값 정수       소수점 첫 번째 자리에서 절삭
        ,TRUNC(5/3)         -- 절삭, TRUNC( [, m 절삭위치]) m 번째 자리에서 절삭
        ,MOD(5,2)           -- 나머지 2
        -- 5 % 2 나머지 연산자 X
FROM dual;
-- TRUNC()
-- 형식 ) TRUNC (a [,b])
SELECT
--3.141592 pi
--3.1415926535897932384626433832795028842
    TRUNC(12345.6789, -1)
     TRUNC(12345.6789, -2)
    ACOS (-1) pi
    ,TRUNC( ACOS(-1))
    ,FLOOR( ACOS(-1))
    ,TRUNC( ACOS(-1), 2)
    ,TRUNC( ACOS(-1), 3)
    
    ,FLOOR (ACOS(-1)*100)/100  -- 소수점 3자리에서 절삭 3.14
FROM dual;
--  숫자 -> 원하는 형식*format 으로 출력

SELECT ename, hourly_pay
    ,TO_CHAR(hourly_pay, 'C9,999.999')
FROM (
        SELECT ename
        , sal+NVL(comm, 0) pay
        , (sal+NVL(comm, 0)) /(20*8) 
        , TRUNC((sal + NVL(comm, 0))/(20*8), 3) hourly_pay -- 시간당 급여
FROM emp
) e;

-- divisor : 제수, 나누는 수
-- dividend : 피제수, 나누어지는 수
--SELECT 5/0
SELECT  MOD(5,0)  --5
FROM dual;
-- 1) 비교연산자. : WHERE 절, 숫자, 날짜, 문자를 비교하는 연산자
--      >< >= <= = != ^= <>
SELECT 5>3 -- WHERE 절 사용 X
FROM dual;

-- [문제] 입사일자 81/06 ~ 81/10 입사한 사원 정보를 조회하고 싶다
--[1]
SELECT ename, hiredate
FROM emp
WHERE  TO_CHAR(hiredate, 'YYMM') BETWEEN 8106 AND 8110
ORDER BY hiredate ASC;

--[2]
SELECT ename, hiredate
FROM emp
    WHERE  TO_CHAR(hiredate, 'MM') >=6 
    AND TO_CHAR (hiredate, 'MM') <=10
    AND TO_CHAR (hiredate, 'MM') = 81
ORDER BY hiredate ASC;

--[3]
SELECT ename, hiredate
FROM emp
WHERE  hiredate BETWEEN '81/06/01' AND '81/10/31'

ORDER BY hiredate ASC;
--날짜 절삭
--절삭 함수 : TRUNC (NUMBER[, 위치]), == FLOOR (NUMDER)
SELECT SYSDATE
        ,TRUNC (SYSDATE, 'yyyy')
        ,TRUNC (SYSDATE, 'mm')
        ,TRUNC (SYSDATE, 'dd')
FROM dual;

--[문제] emp 에서 pay 가장 많이 받는 사람 조회.   - 5000
--[문제] emp 에서 pay 가장 적게 받는 사람 조회.   - 800

SELECT sal + NVL(comm, 0) pay
FROM emp
SELECT MAX (sal + NVL(comm, 0)) max_pay
FROM emp
SELECT MIN (sal + NVL(comm, 0)) min_pay
FROM emp;
--ORDER BY pay DESC;
--
SELECT COUNT(*)
FROM emp
WHERE deptno = 30;

--[문제] emp 테이블에서 max pay 받는 사원 정보 조회
--[문제] emp 테이블에서 min pay 받는 사원 정보 조회
--[문제] emp 테이블에서 min pay, max pay 받는 사원 정보 조회