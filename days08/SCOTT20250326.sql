-- SCOTT
--[문제] insa 테이블에서 여자사원수가 5명 이상인 부서명, 사원수 조회...
------------------------------------------------------------
select *
from insa;

-- 부서들의 사원수
SELECT buseo, COUNT(*)
FROM insa
GROUP BY buseo;
-- 여자 사원수
SELECT buseo, COUNT(DECODE (MOD(SUBSTR(ssn, -7, 1), 2), 0, '여자') )-- 남자는 null
FROM insa
GROUP BY buseo;
-- 여자, 남자 사원수 (1)
SELECT buseo
    ,COUNT(DECODE (MOD(SUBSTR(ssn, -7, 1), 2), 0, '여자') ) "여자 사원수"
    ,COUNT(DECODE (MOD(SUBSTR(ssn, -7, 1), 2), 1, '남자') ) "남자 사원수"
FROM insa
GROUP BY buseo
HAVING COUNT (DECODE (MOD(SUBSTR(ssn, -7, 1), 2),0, '여자') ) >= 5;

--(2) 각 부서별 여자 사원수만 출력
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0 --AND jikwi = '사원'
GROUP BY buseo
HAVING COUNT(*) >= 5
ORDER BY buseo ASC;
------------------------------------------------------------
--[문제] emp 테이블에서 사원 전체 평균 급여보다 사원의 급여(pay)가 많으면 "많다", "적다"
select *
from emp;
--(1)
SELECT ename, sal
        ,CASE WHEN sal > (
                SELECT AVG(sal) FROM emp) THEN '많다'
                ELSE '적다'
END AS 평가
FROM emp;

--(2)
SELECT AVG(sal + NVL(comm, 0)) avg_pay
FROM insa
-- (1) UNION || UNION ALL  SET연산자(합집합)
SELECT e.*, '많다' "평가"
FROM emp e
WHERE sal + NVL(comm, 0) > (SELECT AVG(sal + NVL(comm, 0)) avg_pag
FROM emp)
UNION ALL
SELECT e.*, '적다'
FROM emp e
WHERE sal + NVL(comm, 0) > (SELECT AVG(sal + NVL(comm, 0)) avg_pag
FROM emp);

--(2) DECODE() = , [CASE 함수]
SELECT e.ename, e.pay, e.avg_pay
FROM (
    SELECT emp.*,
           sal + NVL(comm, 0) AS pay,  -- AS 추가
           (SELECT AVG(sal + NVL(comm, 0)) FROM emp) AS avg_pay  -- AS 추가, avg_pag -> avg_pay
    FROM emp
) e;

--(3)
SELECT e.ename, e.pay, e.avg_pay,
       NVL2(NULLIF(SIGN(e.pay - e.avg_pay), 1), '적다', '많다') AS "평가"
FROM (
    SELECT emp.*,
           sal + NVL(comm, 0) AS pay,
           (SELECT AVG(sal + NVL(comm, 0)) FROM emp) AS avg_pay  -- avg_pag -> avg_pay
    FROM emp
) e;
--
SELECT SIGN(100), SIGN(-100), SIGN (0)
FROM dual;
------------------------------------------------------------
--[문제] emp 테이블에서 급여 MAX, MIN 사원의 정보(부서명, 이름, job, 입사일자,pay) 조회
--(1)
SELECT d.dname, e.ename, job, hiredate ,sal + NVL(e.comm, 0) pay
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno
WHERE sal + NVL(e.comm, 0) IN (

(SELECT MAX(sal + NVL(comm, 0 )) max_pay FROM emp)
,(SELECT MIN(sal + NVL(comm, 0 )) min_pay FROM emp)
);
------------------------------------------------------------
--(2)
WITH temp AS(
(SELECT MAX(sal + NVL(comm, 0 )) max_pay FROM emp)
UNION
(SELECT MIN(sal + NVL(comm, 0 )) min_pay FROM emp)
)
SELECT  d.dname, e.ename, job, hiredate ,sal + NVL(e.comm, 0) pay
    , CASE sal + NVL(e.comm, 0)
        WHEN 5000 THEN 'MAX_PAY'
        ELSE 'MIN_PAY'
    END 평가
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno
WHERE sal + NVL(e.comm, 0) IN ( SELECT * FROM temp );
------------------------------------------------------------
--[문제] insa 테이블에서
-- 서울 출신 사원 중에 부서별 남자, 여자 사사원수
-- 남자급여총합, 여자 급여총합 조회(촐력)

-- BUSEO 남자인원수  여자인원수   남자급여합   여자급여합
-- 개발부      0       2           (null)   1,790,000
-- 기획부      2       1         5,060,000  1,900,000
--;

select *
FROM insa;

--(1)
SELECT
    buseo,
    SUM(CASE WHEN SUBSTR(ssn, 8, 1) IN ('1', '3') THEN 1 ELSE 0 END) AS "남자인원수",
    SUM(CASE WHEN SUBSTR(ssn, 8, 1) IN ('2', '4') THEN 1 ELSE 0 END) AS "여자인원수",
    SUM(CASE WHEN SUBSTR(ssn, 8, 1) IN ('1', '3') THEN basicpay + NVL(sudang, 0) ELSE null END) AS "남자급여합",
    SUM(CASE WHEN SUBSTR(ssn, 8, 1) IN ('2', '4') THEN basicpay + NVL(sudang, 0) ELSE null END) AS "여자급여합"
FROM insa
WHERE city = '서울'
GROUP BY buseo;

--(2)
SELECT buseo,
    SUM(DECODE(SUBSTR(ssn, 8, 1), '1', 1, '3', 1, 0)) AS "남자인원수",
    SUM(DECODE(SUBSTR(ssn, 8, 1), '2', 1, '4', 1, 0)) AS "여자인원수",
    SUM(DECODE(SUBSTR(ssn, 8, 1), '1', basicpay + NVL(sudang, 0), '3', basicpay + NVL(sudang, 0), null)) AS "남자급여합",
    SUM(DECODE(SUBSTR(ssn, 8, 1), '2', basicpay + NVL(sudang, 0), '4', basicpay + NVL(sudang, 0), null)) AS "여자급여합"
FROM insa
WHERE city = '서울'
GROUP BY buseo;

--(3) 강사님 풀이 GROUP BY 사용 안함 x
WITH temp AS
(
   SELECT *   FROM insa   WHERE city = '서울'
)
SELECT DISTINCT buseo 
     , ( SELECT  COUNT(*) FROM temp WHERE buseo= t.buseo  ) 총사원수
     , ( SELECT  COUNT( DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1 , '남'  )) FROM temp WHERE buseo= t.buseo  ) 남사원수
     , ( SELECT  COUNT( DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0 , '여'  )) FROM temp WHERE buseo= t.buseo  ) 여사원수
     , ( SELECT  SUM(basicpay) FROM temp WHERE buseo= t.buseo  ) 총급여합
    , ( SELECT  SUM( DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1 , basicpay  )) FROM temp WHERE buseo= t.buseo  ) 남급여합
    , ( SELECT  SUM( DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0 , basicpay  )) FROM temp WHERE buseo= t.buseo  ) 여급여합
FROM temp t
ORDER BY buseo ASC;

------

WITH temp AS (
   SELECT * FROM insa WHERE city = '서울'
)
SELECT DISTINCT buseo
     , ( SELECT COUNT(*) FROM  temp WHERE buseo = t.buseo ) 총사원수
     , ( SELECT COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, 'O' )) FROM  temp WHERE buseo = t.buseo ) 남사원수
     , ( SELECT COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0, 'O' )) FROM  temp WHERE buseo = t.buseo ) 여사원수
     , ( SELECT SUM(basicpay) FROM  temp WHERE buseo = t.buseo ) 총급여합
     , ( SELECT SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, basicpay )) FROM  temp WHERE buseo = t.buseo ) 남급여합
     , ( SELECT SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0, basicpay )) FROM  temp WHERE buseo = t.buseo ) 여급여합
FROM temp t
ORDER BY buseo ;

--(4) GROUP BY 절 사용
SELECT buseo
    ,COUNT(*) 총 사원수
    ,COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, 'O' )) 남사원수
    ,COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0, 'O' )) 여사원수
    ,SUM(basicpay) 총 급여합
    ,SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, basicpay )) 남급여합
    ,SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0, basicpay )) 여급여합
FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo ASC;

--(5) 
SELECT buseo
--     , DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1 , '남자','여자') 성별
     , CASE MOD(SUBSTR(ssn, -7, 1),2)
          WHEN 1 THEN '남자'
          WHEN 0 THEN '여자'
       END 성별
     , COUNT(*) 사원수
     , TO_CHAR ( SUM(basicpay),'L999,999,999')급여합
FROM insa
WHERE city = '서울'
-- GROUP BY ROLLUP( buseo, MOD(SUBSTR(ssn, -7, 1),2) )
GROUP BY CUBE( buseo, MOD(SUBSTR(ssn, -7, 1),2) )
ORDER BY buseo, MOD(SUBSTR(ssn, -7, 1),2);

------------------------------------------------------------
--[문제] emp 테이블에서 급여(sal) TOP - 5 조회
-- [1] 풀이
SELECT *
FROM (
        SELECT e.*
             , ( SELECT COUNT(*)+1 FROM emp WHERE e.sal < sal  ) sal_rank
        FROM emp e
        ORDER BY sal_rank ASC
    ) t
WHERE sal_rank BETWEEN 3 AND 5;    
WHERE sal_rank <= 5    

--[2] 풀이 TOP N 방식

SELECT t.*
FROM (
        SELECT e.*, ROWNUM seq
        FROM (
                SELECT *
                FROM emp
                ORDER BY sal DESC
             ) e
     ) t
WHERE seq BETWEEN 3 AND 5     ;

--ROLLUP : 그룹화하고 그룹에 대한 부분합.
SELECT dname, job
        ,COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno(+) -- OUTER 조인조건
--GROUP BY ROLLUP(dname, job)
GROUP BY CUBE(dname, job) -- 부분합까지 알려면 CUBE 사용
ORDER BY dname ASC;
-- 11 행만 보이는 이유는 ? King 사원번호 null 이기 때문에 제외

--[순위(Rank) 함수]
-- Rank 함수
SELECT ename, sal, comm, sal + NVL(comm, 0) pay
    -- 중복 순위 계산 함 O 
    ,RANK() OVER (ORDER BY sal DESC) "RANK 급여순위"
    -- 중복 순위 계산 안함 X
    ,DENSE_RANK() OVER(ORDER BY sal DESC) "DENSE_RANK  급여순위"
    -- sal 1250 9/9 9/10 동점자 처리방식
    ,ROW_NUMBER() OVER(ORDER BY sal DESC) "ROW_NUMBER  급여순위"    
FROM emp;

--
SELECT sal
FROM emp
WHERE ename LIKE '%JONES';
--
UPDATE emp
SET sal = 2850
WHERE empno = 7566;
COMMIT;

-- [문제] emp 테이블에서 부서별 급여 순위 매겨서 출력(조회)
--[1]
SELECT deptno,e.ename, e.sal,
       (SELECT COUNT(*) + 1
        FROM emp
        WHERE deptno = e.deptno AND sal > e.sal) AS dept_sal_rank
FROM emp e
ORDER BY e.deptno, dept_sal_rank;

--[2] RANK 함수 사용
SELECT *
FROM (
SELECT deptno, ename, sal
    ,RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) dept_rank
    ,RANK() OVER (ORDER BY sal DESC) rank
FROM emp
ORDER BY deptno, dept_rank
)
WHERE dept_rank = 1;
WHERE dept_rank <= 2;
------------------------------------------------------------

--[문제] insa 테이블에서 여자 사원수가 가장 많은 부서명, 여자사원수 출력
-- (1)
SELECT buseo, "여자 사원수"
FROM (
    SELECT buseo, COUNT(*) "여자 사원수"
         , RANK() OVER(ORDER BY  COUNT(*) DESC ) sal_rank
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7,1), 2) = 0
    GROUP BY buseo
)
WHERE sal_rank = 1;
-- (2) TOP-N 분석 방법 X
-- ORA-00937: not a single-group group function
WITH temp AS
(
    SELECT buseo
         , COUNT(*) "여자 사원수" 
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7,1), 2) = 0
    GROUP BY buseo 
    ORDER BY "여자 사원수" DESC
) 
SELECT buseo, "여자 사원수"    -- , ROWNUM -- 의사컬럼
FROM temp
WHERE "여자 사원수" = ( SELECT MAX("여자 사원수") FROM temp  );

------------------------------------------------------------
--[문제] insa 테이블에서 basicpay(기본급)이 상위 10%에 해당하는 사원들의
--  이름, 기본급을 출력

-- 순위 (1)
SELECT name, basicpay
FROM (
    SELECT name, basicpay,
           RANK() OVER (ORDER BY basicpay DESC) AS basic_pay_rank
    FROM insa
)
WHERE basic_pay_rank <= (SELECT COUNT(*) * 0.1 FROM insa);

-- (2)

SELECT *
FROM (
SELECT name, basicpay
    ,PERCENT_RANK() OVER(ORDER BY basicpay DESC) p_rank
FROM insa
)
WHERE p_rank <= 0.1;
------------------------------------------------------------
--[문제] emp 테이블에서 sal 컬럼으로 상/중/하 로 사원의 구분.
--[1] 내 풀이
SELECT ename, sal
        ,CASE
            WHEN sall <= total_count / 3 THEN '상'
            WHEN sall <= total_count / 3 * 2 THEN '중'
            ELSE '하'
        END grade
FROM (
    SELECT ename, sal, RANK() OVER(ORDER BY sal DESC) sall
    ,COUNT(*) OVER() total_count
FROM emp
)
ORDER BY sall;

--[2]
SELECT emp.*, RANK() OVER( ORDER BY sal DESC)"순위"
       , CASE 
            WHEN RANK() OVER( ORDER BY sal DESC) <= (SELECT COUNT(*) FROM emp)/3 THEN '상'
            WHEN RANK() OVER( ORDER BY sal DESC) BETWEEN (SELECT COUNT(*) FROM emp)/3 AND ((SELECT COUNT(*) FROM emp)/3)*2  THEN '중'
            ELSE                                            '하'
        END 등급
FROM emp;

--[3]
SELECT ENAME, SAL, TRUNC(SAL_RANK, 4)
     , CASE WHEN SAL_RANK < 0.33 THEN '하' 
            WHEN SAL_RANK BETWEEN 0.33 AND 0.66 THEN '중' 
            ELSE '상' 
            END RESULT 
FROM (
    SELECT ENAME, SAL, PERCENT_RANK() OVER (ORDER BY SAL ASC) AS SAL_RANK
    FROM EMP
)
ORDER BY SAL_RANK DESC;

--[4] NTILE 분석함수 
SELECT ename, sal
    ,NTILE(3) OVER( ORDER BY sal DESC) n_group
    ,CASE NTILE(3) OVER( ORDER BY sal DESC)
        WHEN 1 THEN '상'
        WHEN 2 THEN '중'
        ELSE '하'
    END
FROM emp;
------------------------------------------------------------
-- FIRST_VAIUE, LAST VALUE 분석 함수
SELECT sal, ename
    ,first_value(sal) over (order by sal DESC)
    ,first_value(ename) over (order by sal DESC)

FROM (
    SELECT *
    FROM emp 
    WHERE deptno = 20
    ORDER BY sal DESC
    );
------------------------------------------------------------
--[문제] emp 테이블에서 ename, pay, 평균급여 출력
--ORA-00937: not a single-group group function
SELECT ename, sal + NVL(comm, 0)pay
    ,(SELECT AVG(sal + NVL(comm, 0) ) FROM emp)avg_pay
FROM emp;

--[문제] insa 테이블에서 주민등록번호 생일 지났다. 지나지 않았다. 오늘이 생일이다
select *
from insa;
-- 오늘이 생일 사원을 만드자. 1002 이순신 800812-1544236
-- 오늘이 생일 사원을 만드자. 1002 이순신 800325-1544236 UPDATE 하는 쿼리 작성
SELECT SYSDATE --'25/03/25'
        ,TO_CHAR(SYSDATE,'MMDD') --'0325'
        ,'800812-1544236'
        , REGEXP_REPLACE('800812-1544236'
        , '^(\d{2})(\d{4})(-d\{7})$'
        , '\1' || '0325' || '\3')
FROM dual;
--------------------
UPDATE insa
-- SET  ssn = SUBSTR( ssn, 1,2)  ||  TO_CHAR( SYSDATE, 'MMDD') || SUBSTR( ssn, -8)  
SET ssn = REGEXP_REPLACE(ssn , '^(\d{2})(\d{4})(-\d{7})$', '\1'|| TO_CHAR( SYSDATE, 'MMDD') || '\3')
WHERE num = 1002;
COMMIT;

-- (2) 생일의 지남 여부 체크
SELECT name, today, birthday
      , today - birthday
      , DECODE( SIGN( today-birthday  ), 0 , '오늘', 1 ,'X', 'O')
--      , CASE 
--            WHEN   today-birthday = 0 THEN '오늘 생일이다.'
--            WHEN   today-birthday < 0 THEN '생일 지나지 않았다.'
--            ELSE   '생일이 지났다.'
--        END
FROM (
    SELECT name, ssn 
       , TRUNC( SYSDATE )  today
       , TO_CHAR( TRUNC( SYSDATE ), 'DS TS')
       , TO_DATE( SUBSTR(ssn, 3, 4 ) , 'MMDD' )  birthday
       , TO_CHAR( TO_DATE( SUBSTR(ssn, 3, 4 ) , 'MMDD' ), 'DS TS')
    FROM insa
);

--[문제] insa 테이블에서 주민등록번호를 사용해서 만나이를 계산해서 출력
--      만나이 = 올해년도(2025) - 생일년도(1977) -1 생일지나지 않으면
--      입력 insa 테이블 name, ssn 컬럼
--      출력 name, ssn, 만나이, 한국나이
--[1] 내가 푼 문제
SELECT
    name,
    ssn,
    EXTRACT(YEAR FROM SYSDATE) - (
        CASE
            WHEN SUBSTR(ssn, -7, 1) IN ('1', '2', '5', '6') THEN 1900
            WHEN SUBSTR(ssn, -7, 1) IN ('3', '4', '7', '8') THEN 2000
            WHEN SUBSTR(ssn, -7, 1) IN ('9', '0') THEN 1800
            ELSE NULL  -- 주민번호 오류 처리
        END + TO_NUMBER(SUBSTR(ssn, 1, 2))
    ) - (CASE WHEN TO_CHAR(SYSDATE, 'MMDD') < SUBSTR(ssn, 3, 4) THEN 1 ELSE 0 END) AS "만나이",

    EXTRACT(YEAR FROM SYSDATE) - (
        CASE
            WHEN SUBSTR(ssn, -7, 1) IN ('1', '2', '5', '6') THEN 1900
            WHEN SUBSTR(ssn, -7, 1) IN ('3', '4', '7', '8') THEN 2000
            WHEN SUBSTR(ssn, -7, 1) IN ('9', '0') THEN 1800
            ELSE NULL
        END + TO_NUMBER(SUBSTR(ssn,1,2))

    ) + 1 AS "한국나이"
FROM insa;

----------------------------
--[2] 강사님 풀이

SELECT name, ssn
      , 올해년도 - 출생년도  - DECODE( bsign, 1, 1 , 0  )  만나이
FROM ( 
    SELECT name, ssn
       , TO_CHAR( SYSDATE, 'YYYY' ) 올해년도
       , SUBSTR(ssn, -7, 1) 성별
       , SUBSTR( ssn, 1, 2) 생일의2자리년도
       , CASE 
             WHEN SUBSTR(ssn, -7, 1) IN (1,2,5,6) THEN 1900
             WHEN REGEXP_LIKE(SUBSTR(ssn, -7, 1), '[3478]') THEN 2000
             ELSE 1800
         END + SUBSTR( ssn, 1, 2)  출생년도
       , SIGN( TO_DATE( SUBSTR( ssn, 3,4)  , 'MMDD' ) - TRUNC( SYSDATE ) ) bsign
         -- 생일이 지나지 않으면 1      -1살 
    FROM insa
) ;

------------------------------------------------------------
--Math.random() 임의의 수
--Random rnd ;  rnd.nextInt(1, 46)
-- DBMS_RANDOM 패키지 : 서로 관련된 함수, 프로시저 등을 몪어 놓은 것
SELECT DBMS_RANDOM.VALUE            --0<= 실수  <1
        ,DBMS_RANDOM.VALUE(1, 46)   --1<= 실수 < 46
        ,FLOOR (DBMS_RANDOM.VALUE(1, 46)) --1 ~ 45 정수 로도번호
FROM dual;

SELECT DBMS_RANDOM.STRING('X', 10) -- 대문자 + 숫자
        ,DBMS_RANDOM.STRING('U', 10) -- 대문자
        ,DBMS_RANDOM.STRING('L', 10) -- 소문자
        ,DBMS_RANDOM.STRING('P', 10) -- 대문자 + 소문자 + 숫자 +특수문자
        ,DBMS_RANDOM.STRING('A', 10) -- 알파벳
FROM dual;

SELECT DBMS_RANDOM.RANDOM -- -21억 ~ 정수 ~ 21억
FROM dual;

-- 로또번호 (1~445) 정수
-- 국어점수 (0~100) 정수
-- 인증번호 6자리 출력
SELECT FLOOR(DBMS_RANDOM.VALUE(100000,100000))
        ,TRUNC(DBMS_RANDOM.VALUE(100000,100000))
FROM dual;

-- 무작위로 사원 5명 SELECT  쿼리
SELECT *
FROM (SELECT * FROM emp ORDER BY DBMS_RANDOM.VALUE)
WHERE ROWNUM <= 5;

SELECT ename, job, hiredate
FROM emp
ORDER BY 3 ASC;

------------------------------------------------------------
-- [문제] emp 테이블에서 각 부서별 최고 급여자, 최저 급여자 사원정보 조회
SELECT *
FROM emp
WHERE (deptno, sal) IN (
    SELECT deptno, MAX(sal)
    FROM EMP
    GROUP BY deptno
)                                             
                 OR (deptno, sal) IN (  -- OR 조건 추가
    SELECT deptno, MIN(sal)
    FROM emp
    GROUP BY deptno
);

--
SELECT e.*
FROM emp e
JOIN (
    SELECT deptno, MAX(sal) AS max_sal, MIN(sal) AS min_sal
    FROM emp
    GROUP BY deptno
) dept_stats ON e.deptno = dept_stats.deptno  -- AS 제거
                 AND (e.sal = dept_stats.max_sal OR e.sal = dept_stats.min_sal);

                    
-- 1.[풀이]
SELECT *
FROM emp m
WHERE sal IN (
            (SELECT MAX(sal) FROM emp WHERE deptno = m.deptno)
            ,(SELECT MIN(sal) FROM emp WHERE deptno = m.deptno)
            )
ORDER BY deptno ASC, sal DESC;

-- 2.[풀이]
SELECT m.*
FROM (
        SELECT e.*
            ,RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) saldesc
            ,RANK() OVER(PARTITION BY deptno ORDER BY sal ASC) salasc
    FROM emp e
) m
WHERE saldesc = 1 OR salasc = 1;

--3. [풀이]
SELECT a.*
FROM emp a, (SELECT deptno,  MAX(sal) max, MIN(sal) min FROM emp GROUP BY deptno) b
WHERE a.sal = b.max OR a.sal = b.min  AND a.deptno = b.deptno
ORDER BY a.deptno, sal DESC;

--4. [풀이]
 WITH t AS (
    SELECT emp.*
       , RANK() OVER(ORDER BY sal DESC) r
    FROM emp
), s AS (
    SELECT MAX(r)mr
    FROM t 
)
SELECT empno, ename, sal, r
FROM t
WHERE r IN (1, (SELECT mr FROM s));
