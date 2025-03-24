--(1)
SELECT 10, COUNT(*) FROM emp WHERE deptno = 10
UNION ALL
SELECT 20, COUNT(*) FROM emp WHERE deptno = 20
UNION ALL
SELECT 30, COUNT(*) FROM emp WHERE deptno = 30
UNION ALL
SELECT 40, COUNT(*) FROM emp WHERE deptno = 40
UNION ALL
SELECT null, COUNT(*) FROM emp; -- 칼럼 갯수를 맞추려고

--(2) 상관 서브 쿼리 + 부서는 10/20/30/40 (40 0명 출력)
SELECT DISTINCT deptno
    ,(SELECT COUNT(*) FROM emp WHERE deptno = e.deptno) 사원수
FROM emp e
ORDER BY deptno ASC;
--
SELECT deptno
  ,(SELECT COUNT(*) FROM emp WHERE deptno = d.deptno) 사원수
FROM emp d
ORDER BY deptno ASC;
--(3) GROUP BY 절.
SELECT deptno,COUNT(*)
FROM emp
GROUP BY deptno
UNION ALL
SELECT 40, COUNT(*) FROM emp WHERE deptno = 40
ORDER BY deptno ASC;

--(4) dept 부서 테이블 10 ~ 40
--    emp 사원 테이블 10 ~ 30 40 ㅌ
SELECT d.deptno, dname, COUNT(ename)
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno -- OUTER JOIN
GROUP BY d.deptno, dname
ORDER BY d.deptno ASC;
-- 위의 JOIN 쿼리를 JOIN ON 구문 으로 수정
SELECT d.deptno, dname, COUNT(ename)
FROM dept d RIGHT OUTER ON JOIN emp dept e, e.deptno = d.deptno
WHERE e.deptno(+) = d.deptno -- OUTER JOIN
GROUP BY d.deptno, dname
ORDER BY d.deptno ASC;

SELECT *
FROM dept;
------------------------------------------------------------
SELECT    
     (SELECT COUNT (*) FROM emp WHERE deptno = 10)
    ,(SELECT COUNT (*) FROM emp WHERE deptno = 20)
    ,(SELECT COUNT (*) FROM emp WHERE deptno = 30)
    ,(SELECT COUNT (*) FROM emp WHERE deptno = 40)
    ,(SELECT COUNT (*) FROM emp )
FROM dual;

--DECODE 함수...(기억)
--1) if  문 대신에 사용할 함수 -> SQL. PL/SQL 사용
--2) SELECT 사용시 FROM 만 제외하고 어디든지 사용 가능
--3) 단점 : 비교 연산은 '='만 가능하다. -> CASE 함수

--ex 1) 
if (A == B){
    return C;
}else
    return D;
}
==> DECODE (A,B,C,D);
--ex 2)
if (a == b) {
    return ㄱ;
}else if (A == D){
    return ㄴ;
}else if{
    return ㄷ;
}else{
    return ㄹ;
}
==> DECODE (A,B,ㄱ,C,ㄴ,D,ㄷ,ㄹ);
------------------------------------------------------------

--[문제] insa 테이블에서 이름, 주민번호, 성별 ('남자', '여자') 출력
SELECT name, ssn
        ,NVL2(NULLIF(MOD(SUBSTR(ssn 8,1),2),1, 'O','X') AS gender
        ,REPLACE(REPLACE(MOD(SUBSTR(ssn 8,1),2),1,'X'), 0, 'O') AS gender
        ,DECODE(MOD (SUBSTR (ssn, 8, 1), 2),1, '남자', '여자') as gender
        ,DECODE(MOD (SUBSTR (ssn, 8, 1), 2),1, '남자', 0, '여자') as gender
        --CASE 함수 추가
        ,
FROM insa;

--[문제] insa 테이블에서 이름, 주민번호, 성별 ('남자', '여자') 출력
SELECT name, ssn,
       CASE
           WHEN SUBSTR(ssn, 8, 1) IN ('1', '3') THEN '남자'
           WHEN SUBSTR(ssn, 8, 1) IN ('2', '4') THEN '여자'
           ELSE '기타'  -- 또는 NULL
       END AS gender
FROM insa;
------------------------------------------------------------


--[문제] DECODE() 함수 사용
-- emp 테이블의 각 부서의 사원수 조회 (암기)
SELECT COUNT(*)
    ,COUNT(DECODE(deptno, 10, empno)) "10"
    ,COUNT(DECODE(deptno, 20, empno)) "20"
    ,COUNT(DECODE(deptno, 30, empno)) "30"
    ,COUNT(DECODE(deptno, 40, empno)) "40"
FROM emp;
-- 위의 쿼리 설명
SELECT
    --COUNT(comm) --NULL 값은 제외한다
     DECODE(deptno, 10, empno) "10"
    ,DECODE(deptno, 20, empno) "20"
    ,DECODE(deptno, 30, empno) "30"
    ,DECODE(deptno, 40, empno) "40"
FROM emp;

--[문제] emp 테이블에서 pay 모두 10% 인상하는 쿼리
SELECT empno, ename, sal, comm
    ,sal + NVL(comm, 0) pay
    ,sal + NVL(comm, 0) * 1.1 "10% 인상된 pay"    
FROM emp;

--[문제] emp 테이블에서 10번 pay 15% 인상, 20번 pay 10% 인상
--              그 외 부서는 20% 인상
--              (DECODE 함수를 사용)
SELECT empno, ename, sal, comm
    ,sal + NVL(coom, 0)pay
    ,DECODE( deptno, 10, (sal+NVL(comm, 0))* 1.15
                   , 20, (sal+NVL(comm, 0))* 1.1
                   , (sal+NVL(comm, 0))* 1.2) "인상된 PAY"
    ,(sal+NVL(comm, 0)) * DECODE( deptno, 10, 1.15)
                                            ,20, 1.1
                                                ,1.2)"인상된 PAY"
    ,(sal+NVL(comm, 0)) ,CASE deptno(컬럼명 WHEN 10 THEN(수식)
                        WHEN 20 THEN
                        :
                        ELSE
    END 별칭
    FROM emp;

--CASE 함수
------------------------------------------------------------
-- (분석, 이해, 암기) 내일 시험
SQL> select count(case when to_char(hiredate,'MM') ='01' then count(*) end) as jan,
         count(case when to_char(hiredate,'MM') ='02' then count(*) end) as feb,
         count(case when to_char(hiredate,'MM') ='03' then count(*) end) as Mar,4         
         count(case when to_char(hiredate,'MM') ='04' then count(*) end) as Apr,
         count(case when to_char(hiredate,'MM') ='05' then count(*) end) as May,
         count(case when to_char(hiredate,'MM') ='06' then count(*) end) as Jun,
            count(*) Total
    from emp
    group by hiredate;
------------------------------------------------------------
SELECT SYSDATE
        ,ROUND (SYSDATE)        -- 25/03/24 12시 지난 후에는 24 -> 25
        ,ROUND (SYSDATE,'DD')   -- 25/03/24 정오를 기준으로 날짜가 반올림
        ,ROUND (SYSDATE,'MM')   --[24] 25/04/01 15일을 기준으로 날짜가 반올림
        ,ROUND (SYSDATE,'YEAR')
FROM dual;
------------------------------------------------------------
SELECT SYSDATE
--        ,TO_CHAR(SYSDATE, 'DS TS')
--        ,TRUNC (SYSDATE)    -- 시간, 분, 초 절삭
--        ,TO_CHAR(TRUNC(SYSDATE), 'DS TS') --25/03/24	2025/03/24 오후 12:03:50
        ,TRUNC(SYSDATE, 'MM')
        ,TO_CHAR(TRUNC (SYSDATE,'MM'),'DS TS')
        ,TRUNC (SYSDATE ,'YEAR')
        ,TO_CHAR(TRUNC(SYSDATE,'YEAR'), 'DS TS')
FROM dual;

--ROUND (숫자 또는 날짜)
--TRUNC (숫자 또는 날짜)
------------------------------------------------------------
SELECT SYSDATE
        ,SYSDATE + 7
        ,SYSDATE - 7
        ,SYSDATE + 1/24 -- 1시간 더하기
FROM dual;

select ename, hiredate
        ,CEIL(sysdate - hiredate)+ 1 근무일수
from emp;

------------------------------------------------------------
--[문제] 개강일로 부터 오늘까지 몇 일이 지나는지? 25/2/3 개강 - 오늘날짜.
SELECT TRUNC(SYSDATE) - TO_DATE('25/02/03', 'YY/MM/DD')
FROM dual;

------------------------------------------------------------
-- emp 사원테이블의 근무일수, 근무개월수, 근무년수 조회
SELECT ename, hiredate, SYSDATE
       ,CEIL(sysdate - hiredate)+ 1 근무일수
        -- 소수점 3번째 자리에서 반올림
       ,ROUND(MONTHS_BETWEEN (SYSDATE, hiredate), 2) 근무개월수
       ,MONTHS_BETWEEN(SYSDATE, hiredate)/12 근무년수
FROM emp;
------------------------------------------------------------
--[문제] 설문조사
--                시작일 25.3.20 오전 9시부터
--                종료일 25.3.24 낮 12시까지
--                지금은 설문이 가능한지 여부를 조회... 25.23.24 오후 12:55 X
--(1)
SELECT
    CASE
        WHEN SYSDATE BETWEEN TO_DATE('2025/03/20 09', 'YYYY/MM/DD HH24')
                         AND TO_DATE('2025/03/24 12', 'YYYY/MM/DD HH24')
        THEN '설문 가능'  -- WHEN 절에 THEN 추가
        ELSE '설문 불가능'  -- ELSE 절 추가
    END AS 설문가능여부  -- CASE 문에 END와 alias 추가
FROM dual;

--(2)
SELECT SYSDATE
--    ,TO_CHAR(SYSDATE, 'DS TS')
    ,TO_DATE('25.3.20 9', 'YY.MM.DD.HH')
--    ,TO_CAHR('2025/03/24 9', 'YY.MM.DD HH'), 'DS TS')
    ,TO_DATE('25.3.24 13', 'YY.MM.DD.HH24')
--    ,TO_CAHR('2025/03/24 12', 'YY.MM.DD HH'), 'DS TS')
    CASE WHEN SYSDATE BETWEEN AND THEN TO_DATE('25.3.20 9', 'YY.MM.DD.HH') AND TO_DATE('25.3.24 13', 'YY.MM.DD.HH24') 
    ELSE '설문 불가능'
    END "설문조사 여부"
FROM dual;
------------------------------------------------------------
SELECT SYSDATE
    , SYSDATE + 3 -- 3일후
    , SYSDATE - 3 -- 
    ,ADD_MONTHS (SYSDATE,  1)
    ,ADD_MONTHS (SYSDATE, -1)
    ,ADD_MONTHS (SYSDATE, 12)
    ,ADD_MONTHS (SYSDATE, -12)
FROM dual;
------------------------------------------------------------
SELECT SYSDATE
    ,LAST_DAY(SYSDATE)
    ,TO_CHAR(LAST_DAY(SYSDATE),'DD')
    ,TO_CHAR(TO_DATE('25/04/01')-1, 'DD')
FROM dual;
------------------------------------------------------------
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'DY')    -- '월'
    , TO_CHAR(SYSDATE, 'DAY')   -- '월요일'
    , NEXT_DAY(SYSDATE, '금') -- 25/03/28
    , NEXT_DAY(SYSDATE, '월') -- 25/03/31
FROM dual;
------------------------------------------------------------
SELECT CURRENT_DATE, CURRENT_TIMESTAMP
FROM dual;
------------------------------------------------------------
--[문제] 5월 첫 번째 목요일날 휴강합니다
SELECT 
--    ,TO_DATE('25', 'YY') --년도 -> 날짜 변환 25/03/01
--    ,TO_CHAR('25/05', 'YY/MM') -- 25/05/01
--    ,NEXT_DAY(TO_DATE('25/05', 'YY/MM'),'목')
--    LAST_DAY(ADD_MONTHS(TO_DATE('25/05'))
    NEXT_DAY(TO_DATE('25/05', 'YY/MM') -1,'목')
FROM dual;

------------------------------------------------------------
SELECT 1234
    ,'1234'
    ,TO_NUMBER('1234')
FROM dual;
-- 순자, 문자, 날짜 -> TO_CHAR() 문자 변환하는 함수

SELECT num, name
    ,basicpay, sudang
    ,basicpay + sudang pay
    ,TO_CHAR(basicpay + sudang, 'L9G999G99D00') pay
FROM insa;

SELECT 100
    , TO_CHAR(100,'S9999')
    , TO_CHAR(-100, 'S9999')

    , TO_CHAR(100, '9999MI')
    , TO_CHAR(-100, '9999MI')
    
    , TO_CHAR(100, '9999PR')
    , TO_CHAR(-100, '9999PR') -- <100> 

FROM dual;

SELECT ename, (sal+NVL(comm, 0)) * 12 연봉
    ,TO_CHAR((sal+NVL(comm, 0))* 12, 'L9,999,999.00')
FROM emp;
------------------------------------------------------------
-- [문제]         Date 날짜 -> 내가 원하는 문자열 반환해서 출력. TO_CHAR()
--insa 테이블에서 입사일자를 '1998년 10월 11일 일요일' 형식으로 출력

select *
from insa;

SELECT name, ibsadate
--        ,TO_CHAR(ibsadate, 'YYYY.MM.DD DAY')
--        ,TO_CHAR(ibsadate, 'DL')
        ,TO_CHAR(ibsadate, 'YYYY"년 "MM"월" DD"일"')
--        ,TO_CHAR(ibsadate, 'YYYY')||'년 '||TO_CHAR(ibsadate, 'MM')||'월 '||TO_CHAR(ibsadate, 'DD') || '일 ' || TO_CHAR(ibsadate, 'DAY')
FROM insa;
------------------------------------------------------------
SELECT ename
    ,sal + NVL(comm, 0) pay
    ,sal + NVL2(comm, comm, 0) pay -- null == comm / null != 0
    -- 나열해 놓은 값을 순차적으로 체크하여 NULL이 아닌 값을 리턴하는 함수
    ,COALESCE(sal + comm, sal)
FROM emp;
------------------------------------------------------------
--              *NULL 컬럼값도 포함
--                      컬럼명     컬럼명     NULL 포함 X
SELECT COUNT(*), COUNT(ename), COUNT(comm)
        ,SUM(comm)
        ,AVG(comm)  -- 550  총합/4
        ,SUM(comm) / COUNT(comm) --550
--        ,SUM(sal)
--        ,SUM(sal) / COUNT(*)    -- 2077.083333333333333333333333333333333333
--        ,AVG(sal)               -- 2077.083333333333333333333333333333333333
--        ,SUM(comm) / COUNT(*)     -- 주의
--        ,SUM(comm) / COUNT(comm)  -- 주의
--SELECT sal
FROM emp;

20명     국어시험(18)    2명 X
        반 국어 평균
------------------------------------------------------------
SELECT MAX (sal),MIN(sal)
FROM emp;

-- GROUP BY 절 + HAVING 절 + 추가적 설명
-- [문제] insa 테이블에서 총 사원수, 남자사원수, 여자사원수를 조회
--1) UNION ALL
SELECT '전체' "종류",   COUNT(* ) "사원수"
FROM insa
UNION ALL
SELECT '남자', COUNT(*)  
FROM insa
WHERE MOD( SUBSTR(ssn, -7,1), 2 ) = 1
UNION ALL
SELECT '여자', COUNT(*)  
FROM insa
WHERE MOD( SUBSTR(ssn, -7,1), 2 ) = 0;

--2)
--COUNT(), DECODE() || CASE 함수
SELECT COUNT(*) "총 사원수"
    ,COUNT(DECODE( MOD( SUBSTR(ssn, -7,1), 2 ),1,'O') ) "남자 사원수"
    ,COUNT(DECODE( MOD( SUBSTR(ssn, -7,1), 2 ),1,'O') ) "남자 사원수"
FROM insa;

--3)
--COUNT(), CASE 함수
SELECT COUNT(*) "총 사원수"
    ,COUNT(CASE MOD( SUBSTR(ssn, -7,1), 2 ) WHEN 1 THEN 'O' END) "남자 사원수"
    ,COUNT(CASE MOD( SUBSTR(ssn, -7,1), 2 ) WHEN 1 THEN 'X' END) "여자 사원수"
FROM insa;
------------------------------------------------------------
--GROUP BY 절
SELECT MOD(SUBSTR(ssn, -7,1),2)
    ,COUNT(*)
FROM insa
GROUP BY MOD (SUBSTR (ssn, -7,1), 2);
--
SELECT 
    CASE MOD(SUBSTR(ssn, -7,1),2)
    WHEN 1 THEN '남자 사원수'
    ELSE '여자 사원수'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY MOD (SUBSTR (ssn, -7,1), 2)
UNION ALL
SELECT NULL, COUNT(*)
FROM insa; 
--
SELECT
    CASE MOD(SUBSTR(ssn, -7,1),2)
    WHEN 1 THEN '남자 사원수'
    WHEN 0 THEN '여자 사원수'
    ELSE '총 사원수'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY ROLLUP ( MOD(SUBSTR(ssn, -7, 1),2) );

--예제)
SELECT deptno, job, sal
FROM emp
ORDER BY deptno ASC;
--
SELECT deptno, job, SUM(sal) --deptno, job 을 가진 사람들의 부서 합
FROM emp
--GROUP BY ROLLUP (deptno, job)
GROUP BY CUBE(deptno,job)
ORDER BY deptno ASC;

--[문제] 각 부서별 최고 급여 사원 정보 조회
--[문제] 각 부서별 최고 급여액 정보 조회... (GROUP BY 절 사용)

SELECT deptno
    ,MAX(sal + NVL(comm, 0)) maxpay
    ,MIN(sal + NVL(comm, 0)) minpay
    ,SUM(sal + NVL(comm, 0)) sumpay
    ,AVG(sal + NVL(comm, 0)) avgpay
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

--[문제] emp 테이블에서 가장 급여(pay)를 많이 받는 사원의 정보를 조회
SELECT MAX (sal + NVL(comm,0) ) maxpay
FROM emp;

SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (
                        SELECT MAX(sal + NVL(comm, 0) )maxpay
                        FROM emp
                        );
-- WHERE sal+NVL(comm, 0) = 5000;

-- SQL 연산자
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= ALL (
                        SELECT(sal + NVL(comm, 0) )maxpay
                        FROM emp
                        );
                        
WHERE sal+NVL(comm,0) >= ALL (
                        SELECT(sal + NVL(comm, 0) )maxpay
                        FROM emp
                        );
--EXISTS
SELECT ename, job, sal
FROM emp p
WHERE EXISTS (
        SELECT 'x' FROM dept
        WHERE deptno = p.deptno
        );
--IN
SELECT ename, job, sal, deptno
FROM emp p
WHERE deptno  IN(
            SELECT  deptno
            FROM dept
            WHERE deptno = p.deptno
            );
            
-- KING 10 -> null 처리...(수정)
UPDATE emp
SET deptno = null
WHERE empno = 7839;
--
SELECT *
FROM emp;
--
COMMIT;
--

-- 각 부서별 최고 급여자
SELECT deptno, empno, ename, sal + NVL(comm,0) pay
    ,(  SELECT COUNT(*)+1
        FROM emp
        WHERE sal + NVL(comm,0) > e.sal + NVL(e.comm,0) )  payrank
     , (  SELECT COUNT(*)+1
        FROM emp
        WHERE (sal + NVL(comm,0) > e.sal + NVL(e.comm,0) ) AND deptno = e.deptno) dept_payrank
FROM emp e
ORDER BY deptno ASC, dept_payrank;

------------------------------------------------------------

SELECT *
FROM (
    SELECT deptno, empno, ename, sal + NVL(comm,0) pay
         , (  SELECT COUNT(*)+1 FROM emp WHERE sal + NVL(comm,0) > e.sal + NVL(e.comm,0) )  payrank
         , (  SELECT COUNT(*)+1 FROM emp WHERE sal + NVL(comm,0) > e.sal + NVL(e.comm,0) AND deptno = e.deptno )  dept_payrank
    FROM emp e
    ORDER BY deptno ASC, dept_payrank ASC
)
WHERE dept_payrank <= 2;
WHERE dept_payrank = 1;
------------------------------------------------------------
--[문제] insa 테이블에서 부서별 사원수가 10명 이상인 부서들을 조회
SELECT *
FROM insa;

--1) 함수 GROUP BY && HAVING 절 사용
SELECT buseo, COUNT(*) cnt -- ORDER BY 에서만 사용가능
FROM insa
GROUP BY buseo HAVING COUNT(*) >= 10;

--2) 사원수도 같이 출력되게 됨
SELECT *
FROM (
SELECT DISTINCT buseo, (SELECT COUNT(*) FROM insa WHERE buseo = i.buseo) cnt
FROM insa i
)
WHERE cnt >= 10;

--3)
WITH temp AS(
SELECT buseo, COUNT(*) cnt
FROM insa
GROUP BY buseo
)
SELECT *
FROM temp
WHERE cnt >= 10;
------------------------------------------------------------
--[문제] insa 테이블에서 여자사원수가 5명 이상인 부서명, 사원수 조회...