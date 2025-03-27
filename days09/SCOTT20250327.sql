-- SCOTT --
--[문제] emp 테이블에서 사원이 존재하지 않는 부서번호, 부서명을 조회
--[1] SET 연산자 : 차집합
WITH t AS(
    SELECT deptno
        FROM dept
MINUS
    SELECT DISTINCT deptno
        FROM emp
WHERE deptno IS NOT NULL
    )
    SELECT  t.deptno, d.dname
        FROM t JOIN dept d ON (t.deptno = d.deptno);

--[2] SQL 연산자 (ANY, SOME, ALL, EXISTS)
SELECT d.deptno, d.dname
    FROM dept d
        WHERE NOT EXISTS ( SELECT empno FROM emp WHERE deptno = d.deptno);
        
--[3]
SELECT d.deptno, d.dname
    FROM dept d
        WHERE( SELECT COUNT( empno ) FROM emp WHERE deptno = d.deptno)= 0;
        
--[4]
SELECT d.deptno, d.dname
    FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
        GROUP BY d.deptno, d.dname
            HAVING COUNT (empno) = 0;
            
-- [문제] GROUP BY, HAVING 절 사용
-- insa 테이블에서 각 부서별(buseo) 여자사원수가 5명 이상인 부서 정보를 출력
-- (이해: WHERE 조건절과 HAVING 조건절의 차이점)
SELECT buseo, COUNT(*)
    FROM insa
        WHERE MOD ( SUBSTR(ssn, -7, 1),2 ) = 0
            GROUP BY buseo
                HAVING COUNT(*) >= 5;
                
-- [문제] insa 테이블
--     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000
SELECT COUNT(*), SUM(basicpay), MAX(basicpay)    
    FROM insa
        WHERE MOD ( SUBSTR(ssn, -7, 1),2 ) = 1;
--    
SELECT COUNT(*), SUM(basicpay), MAX(basicpay)
    FROM insa
        WHERE MOD ( SUBSTR(ssn, -7, 1),2 ) = 0;
-- (남자, 여자) 사원 정보 같이 출력
SELECT COUNT(*) "전체사원수"
    , COUNT(DECODE (MOD( SUBSTR(ssn, -7, 1),2 ), 1,'M') ) "남자사원수"
    , COUNT(DECODE (MOD( SUBSTR(ssn, -7, 1),2 ), 0,'F') ) "여자사원수"
        , SUM(DECODE (MOD( SUBSTR(ssn, -7, 1),2 ), 1,'M') ) "남자사원총급여합"
        , SUM(DECODE (MOD( SUBSTR(ssn, -7, 1),2 ), 0,'F') ) "여자사원총급여합"
            , MAX(DECODE (MOD( SUBSTR(ssn, -7, 1),2 ), 1,'M') ) "남자사원 최대 급여합"
            , MAX(DECODE (MOD( SUBSTR(ssn, -7, 1),2 ), 0,'F') ) "여자사원 최대 급여합"
    FROM insa;

--[2] 풀이
SELECT COUNT(*)
    ,CASE MOD (SUBSTR (ssn, -7, 1),2)
        WHEN 1 THEN '남자'
        WHEN 0 THEN '여자'
            ELSE '전체'
                END gender
                    ,COUNT(*)
                        ,SUM(basicpay)
                            ,MAX(basicpay)
            FROM insa
    GROUP BY ROLLUP (MOD (SUBSTR (ssn, -7, 1),2) );
    
    -- [문제] emp 테이블에서~
--      각 부서의 사원수, 부서 총급여합, 부서 평균급여
--결과)
--    DEPTNO       부서원수       총급여합            평균
---------- ----------       ----------    ----------
--     10          3          8750       2916.67
--     20          3          6775       2258.33
--     30          6         11600       1933.33 
--     40          0         0             0
--[1] 풀이    GROUP BY 절 사용 +
SELECT d.deptno
        ,COUNT(empno) 부서원수
        ,NVL(SUM(sal + NVL(comm, 0)),0) 총급여합
        ,TO_CHAR(ROUND(NVL(AVG(sal + NVL(comm, 0)), 0),2),'9990,00') 평균
    FROM emp e, dept d
        WHERE e.deptno(+) = d.deptno
            GROUP BY d.deptno 
                ORDER BY d.deptno;
                
-- ROLLUP, CUBE 설명 --
-- GROUP BY 절에서 사용되는 구룹별 부부합을 추가로 부여주는 역활
-- 즉, 추가적인 집계 정보를 보여준다.
SELECT MOD (SUBSTR(ssn, -7,1),2) 성별
        ,COUNT(*) 사원수
    FROM insa
        GROUP BY MOD (SUBSTR(ssn, -7,1),2)
UNION ALL
    SELECT null, COUNT(*)
        FROM insa;
----------------------------------------
SELECT MOD (SUBSTR(ssn, -7,1),2) 성별
        ,COUNT(*) 사원수
    FROM insa
--        GROUP BY CUBE(MOD (SUBSTR(ssn, -7,1),2));
        GROUP BY ROLLUP(MOD (SUBSTR(ssn, -7,1),2));
        
-- [ROLLUP / CUBE 차이점]
-- 1차 부서별 그룹핑, 2차 직위별로 그룹핑
SELECT buseo, jikwi
    ,COUNT(*) 사원수
    FROM insa
        GROUP BY buseo, jikwi
            ORDER BY buseo, jikwi
        UNION ALL
SELECT buseo, null
    ,COUNT(*) 사원수
FROM insa       
    GROUP BY buseo
    UNION ALL
        SELECT null, null
            ,COUNT(*)
            FROM insa
                ORDER BY buseo, jikwi;
--[2]
SELECT buseo, jikwi
    ,COUNT(*) 사원수
    FROM insa
        GROUP BY CUBE (buseo, jikwi) -- 부분합 까지 나오는 것이 CUBE
--        GROUP BY ROLLUP (buseo, jikwi)
            ORDER BY buseo, jikwi;
            
-- 분할 ROLLUP --------------------------------------
SELECT buseo, jikwi, COUNT(*) 사원수
    FROM insa
--        GROUP BY ROLLUP (buseo), jikwi          -- 직위에 대한 부분 집계, 전체 집계 X
                GROUP BY buseo, ROLLUP(jikwi)  -- 부서에 대한 부분 집계, 전체 집계 X
--                    GROUP BY buseo, jikwi
                        ORDER BY buseo, jikwi;
--
SELECT buseo, jikwi, COUNT(*) 사원수
    FROM insa  
            GROUP BY GROUPING SETS (buseo, jikwi) -- 그룹핑한 집계만 보고자 할 때
                ORDER BY buseo, jikwi;
                
--[문제] 각 부서별 직위별   최소사원수, 최대사원수 조회.
-- 부서  직위 최소사원수  직위 최대사원수
--개발부   부장     1          사원     9
--기획부   부장     2          대리     3
--  :
select *
from insa;

--[1] 직점 만든 쿼리 ---------------------------
WITH BuseoJikwiCounts AS (
    -- 1단계: 각 부서별, 직위별 사원수 계산 (CTE 정의)
    -- CTE 이름 변경 (buseo -> BuseoJikwiCounts), 내부 ORDER BY 제거
    SELECT
        buseo,
        jikwi,
        COUNT(*) AS 사원수
    FROM insa
    GROUP BY buseo, jikwi
)
-- 2단계: 부서별로 그룹핑하여 최소/최대 사원수 및 해당 직위 찾기
SELECT
    buseo AS "부서",
    -- 최소 사원수를 가진 직위 찾기
    MIN(jikwi) KEEP (DENSE_RANK FIRST ORDER BY 사원수 ASC) AS "최소직위",
    -- 최소 사원수 찾기
    MIN(사원수) AS "최소사원수",
    -- 최대 사원수를 가진 직위 찾기
    MIN(jikwi) KEEP (DENSE_RANK LAST ORDER BY 사원수 ASC) AS "최대직위",
    -- 최대 사원수 찾기
    MAX(사원수) AS "최대사원수"
FROM BuseoJikwiCounts -- FROM 절에서 CTE(BuseoJikwiCounts) 사용
GROUP BY buseo          -- 부서별로 그룹화
ORDER BY buseo;         -- 최종 결과를 부서 순으로 정렬

--[2] 풀이 ---------------------------
WITH a AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
),  b  AS (
    SELECT buseo, MIN(tot_count) buseo_min_count
         , MAX(tot_count) buseo_max_count
    FROM a
    GROUP BY buseo
)
SELECT a.buseo, a.jikwi, a.tot_count
FROM a , b
WHERE a.buseo = b.buseo 
    AND a.tot_count IN ( b.buseo_min_count , b.buseo_max_count)
ORDER BY a.buseo, a.tot_count    ;
-- WHERE a.buseo = b.buseo AND a.tot_count = b.buseo_min_count;

--[3] 풀이 ---(FIRST / LSAT 분석함수 사용)
--            집계함수 (COUNT, SUM ,AVG)

WITH t AS(
    SELECT buseo, jikwi, COUNT(num) tot_count
        FROM insa
            GROUP BY buseo, jikwi
)
SELECT t.buseo
        ,MIN(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count ASC) 직위
        ,MIN(t.tot_count)
        ,MIN(t.jikwi) KEEP(DENSE_RANK LAST ORDER BY t.tot_count ASC) 직위
        ,MAX(t.tot_count)
    FROM t
        GROUP BY t.buseo
            ORDER BY t.buseo ASC;
            
--[문제] emp 테이블에서 사원 정보 조회 ------------------
-- 조건 1) deptno -> dname
-- 조건 2) 직속상사 mgr -> ename
-- 2번 LEFT JOIN
SELECT e.empno, e.ename, e.job, m.ename mgr_ename , e.hiredate , dname
       , e.sal
       , CASE
            WHEN e.sal BETWEEN 700 AND 1200 THEN 1
            WHEN e.sal BETWEEN 1201 AND 1400 THEN 2
            WHEN e.sal BETWEEN 1401 AND 2000 THEN 3
            WHEN e.sal BETWEEN 2001 AND 3000 THEN 4
            WHEN e.sal BETWEEN 3001 AND 9999 THEN 5
         END grade
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno
           LEFT  JOIN emp m  ON e.mgr = m.empno;       
          
-- 같은 방식 WHERE
SELECT e.empno, e.ename, e.job, m.ename mgr_ename, e.hiredate, dname, e.sal
    FROM emp e, dept d, emp m
        WHERE e.deptno = d.deptno AND e.mgr = m.empno;
        
--
SELECT *
FROM salgrade;
----------------------------------------
-- grade losal hisal
--1	700	    1200
--2	1201	1400
--3	1401	2000
--4	2001	3000
--5	3001	9999
SELECT e.empno, e.ename, e.job, m.ename mgr_ename , e.hiredate , dname
       , e.sal
       , grade
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno
           LEFT  JOIN emp m  ON e.mgr = m.empno
           JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;
           
----------------------------------------         
SELECT e.empno, e.ename, e.job, m.ename mgr_ename, e.hiredate, dname
    ,grade
    FROM emp e, dept d, emp m, salgrade s
        WHERE e.deptno = d.deptno(+) AND e.mgr = m.empno(+)
            AND e.sal BETWEEN s.losal AND s.hisal;
            
---------CROSS JOIN---------------------         
SELECT e.deptno, ename, dname
    FROM emp e, dept d;
    
    
-- CUME_DIST() 분석함수
--     ㄴ 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
--     ㄴ  분포도값(비율)   0<    <=1
SELECT deptno, ename, sal
--    ,CUME_DIST() OVER(ORDER BY sal DESC) cd
        ,CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal DESC) cd
        FROM emp;
        
SELECT 1/12, 2/12
FROM dual;
-- NTILE() 함수
-- ㄴ 파티션 별로 expr에 명시된 만큼 분활한 결과를 반환하는 함수
-- ㄴ 분활하는 수를 "버킷(bucket)"이라고 한다
SELECT deptno, ename, sal
    ,NTILE(2) OVER(PARTITION BY deptno ORDER BY sal ASC)ntiles
--    ,NTILE(4) OVER(ORDER BY sal ASC)ntiles
        FROM emp;
        
-- 너비 버킷
-- WIDTH_BUCKET()
-- WIDTH_BUCKET(expression, min_value, max_value, num_buckets) 기본 구문
SELECT ename, sal
    ,WIDTH_BUCKET(sal, 0, 5000, 7) wb_sal
    ,WIDTH_BUCKET(sal, 1000, 4) wb_sal
FROM emp;
--SELECT 3000/4
--FROM dual;
SELECT ename, TRUNC(sal/100+50) score
--CASE ,grade
--DECODE
--WITH
FROM emp;

SELECT deptno, ename, hiredate, sal
    ,LAG(sal, 3, -1) OVER(ORDER BY sal DESC) prev_sal
    ,LEAD(sal, 3, -1) OVER(ORDER BY sal DESC) prev_sal
FROM emp;
--
SELECT t.*
FROM(
    SELECT ename, sal
        ,RANK() OVER(ORDER BY sal DESC) r
        ,LEAD(sal, 1 , -1) OVER(ORDER BY sal DESC)next_sal
    FROM emp
)t
WHERE r = 1 OR next_sal = -1;
---------------------------------------------------------------------------
-- [문제] PIVOT() emp 테이블에서          1~3 1분기, 4~6 2분기, 7~9 3분기 10~12 4분기;
--                  입사년도, 분기별 사원수 출력
--                  1980       1    3
-- 개인 풀이
SELECT hiredate 입사년도
    ,NVL("1분기", 0) AS "1분기"
    ,NVL("2분기", 0) AS "2분기"
    ,NVL("3분기", 0) AS "3분기"
    ,NVL("4분기", 0) AS "4분기"
    FROM emp
FROM (
    SELECT
        EXTRACT(YEAR FROM hiredate) AS hire_year,
        WIDTH_BUCKET(EXTRACT(MONTH FROM hiredate), 1, 13, 4) AS 분기별
    ,empno
FROM emp
)
PIVOT(COUNT(empno) FOR 분기별 IN (
        1 AS "1분기",
        2 AS "2분기",
        3 AS "3분기",
        4 AS "4분기"
    )
)
ORDER BY hire_year;

-- [갓인석 풀이]
SELECT *
    FROM (
        SELECT TO_CHAR(hiredate, 'YYYY') year
--            ,CASE
--                WHEN TO_CHAR(hiredate, 'YYYY') BETWEEN 1 AND 3 THEN 1
--                WHEN TO_CHAR(hiredate, 'YYYY') BETWEEN 4 AND 6 THEN 2
--                WHEN TO_CHAR(hiredate, 'YYYY') BETWEEN 7 AND 9 THEN 3
--                WHEN TO_CHAR(hiredate, 'YYYY') BETWEEN 10 AND 13 THEN 4
--            END q
            ,TO_CHAR(hiredate, 'Q')q
        FROM emp
)
PIVOT(COUNT(*) FOR q IN (1,2,3,4))
ORDER BY year ASC;

--[PIVOT() 사용하지 않고 구현]-------------------------
WITH e AS 
(
   SELECT 
           TO_CHAR( hiredate, 'YYYY' ) y 
           , TO_CHAR( hiredate, 'Q' ) q
   FROM emp
)
SELECT e.y , e.q, COUNT(*) 
    FROM e
        GROUP BY e.y , e.q
            ORDER BY e.y , e.q;
--[ 위의 2번 풀이를 오라클 10g → partition BY () OUTER JOIN 사용]

WITH e AS 
(
   SELECT empno
           ,TO_CHAR( hiredate, 'YYYY' ) y 
           , TO_CHAR( hiredate, 'Q' ) q
   FROM emp
) m AS
(
    SELECT LEVEL q.empno
        FROM dual
            CONNECT BY LEVEL <=4
)
SELECT e.y , e.q, COUNT(empno) 
    FROM e PARTITION BY(e.y) RIGHT JOIN m ON e.q = m.q
        GROUP BY e.y , m.q
            ORDER BY e.y , m.q;
            
--COUNT ~ OVER : 질의한 행의 누적된 행 결과
SELECT name, basicpay
        ,COUNT(*) OVER(ORDER BY basicpay ASC)
    FROM insa;
-- SUM ~ OVER : 
SELECT name, basicpay
    ,SUM(basicpay) OVER(ORDER BY basicpay DESC)
        FROM insa;
-- avg ~ OVER :
SELECT name, basicpay
    ,AVG(basicpay) OVER(ORDER BY basicpay DESC)
        FROM insa;
        
--------------------------------------------------
--자바 자료형 : 기본(8 노b, 정 bsil, c실 fd) 침저향(배,클,인)
--[오라클 자료형(Data type)]
1) CHAR[(SIZE [BYTE|CHAR])]
    고정길이 문자열
    1 ~ 2000 바이트 저장할 수 있느 자료형
    언제 사용 ) name CHAR(10 BYTE) 
        -- DB 끼리 DATE를 주고 받을 때 좋음
        name = "kenik"
        주민등록번호 '000000 - 0000000' CHAR(14)
        -- 고정길이의 문자열을 다룰 때는 좋다
        
    예) 동일한 표현
    CHAR(1, BYTE) == CHAR(1) == CHAR
    CHAR(3, BYTE) == 'abc' == '홍길동' X    
    CHAR(3, BYTE) == 'abc' O '홍길동' O
    
    실습) DDL
    CREATE TABLE tbl_char (
    aa char     -- CHAR(1) == CHAR(1 BYTE)
    ,bb char(3) -- CHAR(3 BYTE)
    ,cc char(3 char)
    );
-- Table TBL_CHAR이(가) 생성되었습니다.
DESC tbl_char;
INSERT INTO tbl_char VALUES ('a', 'aaa', 'aaa');
-- 1 행 이(가) 삽입되었습니다.
INSERT INTO tbl_char VALUES ('b', '한', '한우리');
-- 1 행 이(가) 삽입되었습니다.
--ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."BB" (actual: 9, maximum: 3)
INSERT INTO tbl_char VALUES ('c', '한우리', '한우리'); -- 불가능 c 는 자리가 안생김
COMMIT;
DROP TABLE tbl_char PURGE;
--Table TBL_CHAR이(가) 삭제되었습니다.
--DDL문: CHEATE, ALTER, DROP

-- 2) NCHAR[(SIZE)] 1문자, 2000BYTE
CREATE TABLE tbl_nchar(
    aa char(3)
    ,bb char(3 char)
    ,cc nchar(3) -- u[N]icode
);
-- Table TBL_NCHAR이(가) 생성되었습니다.
INSERT INTO tbl_nchar VALUES ('a', '한우리', 'aaaㄹ');
INSERT INTO tbl_nchar VALUES ('a', '한우리', '한글셋');

--CHAR / NCHAR : 고정길이, 2000byte
DROP TABLE tbl_nchar PURGE;

-- 3) VARCHAR2(SIZE[BYTE|CHAR])
--      ㄴ 가변길이
--      ㄴ 4000 BYTE
    CHAR(10) == CHAR(10 BYTE)
    VARCHAR2(10) == VARCHAR2 (10 BYTE)
    name1 CHAR(10);      ['']['']['']['']['']['']['']['']['']['']
    name2 VARCHAR2(10);   [][][][][][][][][][][]
    name1 = 'abc;
    name2 = 'abc;
    
-- 4) CHAR,NCHAR,
--     VAR + CHAR2 VAR 가변길이    4000 byte 
-- [N]+VAR + CAHR2                4000 byte 

--5) LONG 가변길이 문자열, 2GB

--6) NUMBER[(p[,s])]
    P 1 ~ 38
    S 84 ~ 127
    n NUMBER == n NUMBER(38, 127)
    n NUMBER(5) == n NUMBER(5,0) 정수
    반올림 (기억)
    
    kor NUMBER(3) --999 ~ 999
    avg NUMBER(5,2) --999.99 ~ -999.99
    예)
    CREATE TABLE tbl_number
    (
        name VARCHAR2(10)
        ,kor NUMBER (3)
        ,eng NUMBER (3)
        ,mat NUMBER (3)
        ,tot NUMBER (3)
        ,avg NUMBER (5,2)
    ) -- Table TBL_NUMBER이(가) 생성되었습니다.
--
SELECT * FROM tbl_number;
ROLLBACK;
--1 행 이(가) 삽입되었습니다.
INSERT INTO tbl_number VALUES ('홍길동', 23.22, 199.88, 23, null, null);
--1 행 이(가) 삽입되었습니다.
INSERT INTO tbl_number VALUES ('홍길님', 98, 54, 54, null, null);
INSERT INTO tbl_number VALUES ('서주원', 67, 99, 199, null, null);
--
UPDATE tbl_number
 SET kor= CASE 
             WHEN kor NOT BETWEEN 0 AND 100 THEN null
             ELSE kor
         END
     , eng= CASE 
             WHEN eng NOT BETWEEN 0 AND 100 THEN null
             ELSE eng
         END
     ,mat= CASE 
             WHEN mat NOT BETWEEN 0 AND 100 THEN null
             ELSE mat
         END 
-- WHERE
    tot = kor + eng + mat
    avg
UPDATE
-- 국어, 영어, 수학 null -> 0 처리해서 총점/평균 UPDATE 쿼리를 작성하고 확인
UPDATE tbl_number
 SET tot = NVL(kor, 0) + NVL(eng, 0) + NVL(mat, 0)
    ,avg = (NVL(kor, 0) + NVL(eng, 0) + NVL(mat, 0))/3;
--
DROP TABLE tbl_number PURGE;
-- FLOAT : 내부적으로 NUMBER 타입이다
-- DATE : 날짜 + 시간 => 고정길이 7 BYEE

SELECT emp.*, ROWID -- 메모리의 고유한 ID값
FROM emp;

