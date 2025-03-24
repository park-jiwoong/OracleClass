-- SCOTT --
-- [1] 풀이
SELECT * 
FROM dept;
-- 1 행 이(가) 삽입되었습니다.
INSERT INTO dept VALUES ( 50, 'QC', 'SEOUL');
COMMIT;
-- [2] 풀이
SELECT  *
FROM dept
WHERE dname LIKE '%QC%'; -- REGEXP_LIKE() 함수
-- Java  i = i + 1;
UPDATE dept
SET dname = dname || 2, loc = 'POHANG'   -- CONCAT()
WHERE deptno = 50;
WHERE dname = 'QC';
COMMIT;
-- [ 게시판 ]  조회수 증가 쿼리 작성
UPDATE board
SET   readed = readed + 1
WHERE seq = 10;
-- [3] 풀이
DELETE FROM dept
WHERE deptno = 50;
COMMIT;

-- [8] 풀이
SELECT name, ssn
    , SUBSTR( ssn, 1, 6) || SUBSTR( ssn, -7)  ssn2
    , REPLACE( ssn, '-' ) ssn3
    , REGEXP_REPLACE( ssn, '-' ) ssn4
FROM insa;

--  [11] 풀이  ROUND() /  FLOOR() , TRUNC() / CEIL()
SELECT CEIL(COUNT(*)/14)  팀수
FROM insa;
--  게시판 페이징 처리
-- 총 게시글 수 : 387
-- 한 페이지    : 10
-- 총 페이지 수 : ??
SELECT CEIL(387/10)
FROM dual;

-- [12] 풀이
SELECT empno, ename, sal + NVL(comm, 0) pay
FROM emp
ORDER BY pay DESC;
7839   KING   5000
7369   SMITH   800
-- COUNT()
SELECT MAX(sal + NVL(comm, 0)) maxpay
FROM emp;
SELECT MIN(sal + NVL(comm, 0)) mixpay
FROM emp;
--
SELECT MAX(sal + NVL(comm, 0))  maxpay, MIN(sal + NVL(comm, 0)) minpay
FROM emp;

-- 어떤 사원 정보 조회..  합집합(UNION)  (SET연산자)
SELECT empno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay, deptno, '최고 급여자'
FROM emp
WHERE sal + NVL(comm, 0)  = (
                            SELECT MAX(sal + NVL(comm, 0)) maxpay
                            FROM emp
                            )
UNION
SELECT empno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay, deptno, '최저 급여자'
FROM emp
WHERE sal + NVL(comm, 0)  = (SELECT MIN(sal + NVL(comm, 0)) mixpay
FROM emp);
-- (2)
SELECT empno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay, deptno
FROM emp
WHERE sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) FROM emp) 
     OR sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp);
WHERE sal + NVL(comm, 0) = 800 OR sal + NVL(comm, 0) = 5000;
-- (3) ORA-00913: too many values
SELECT empno, ename, job, mgr, hiredate, sal + NVL(comm, 0) pay, deptno
FROM emp
WHERE sal + NVL(comm, 0) IN ( 
    SELECT MIN(sal + NVL(comm, 0))  maxpay, MAX(sal + NVL(comm, 0)) minpay
    FROM emp
);

WHERE sal + NVL(comm, 0) IN ( 
                     (SELECT MIN(sal + NVL(comm, 0)) FROM emp) 
                    ,  (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
                    );                    
WHERE sal + NVL(comm, 0) IN ( 800 ,  5000 );

--[13]
SELCET ename, sal, comm
FROM emp
WHERE LNNVL(comm > 400);
WHERE comm <= 400 OR comm IS null;

--[14] 각 부서별 최고급여액 / 사원
--ⓐ
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
ORDER BY deptno ASC, pay DESC;
--10	KING	5000
--20	FORD	3000
--30	BLAKE	2850
--ⓑ
SELECT MAX(sal + NVL(comm, 0)) pay
FROM emp
WHERE deptno = 10;

SELECT MAX(sal + NVL(comm, 0)) pay
FROM emp
WHERE deptno = 20;

SELECT MAX(sal + NVL(comm, 0)) pay
FROM emp
WHERE deptno = 30;

--상관 서브쿼리 (서브 + 메인 쿼리)
--ⓒ 20번 부서의 가장 큰 값은
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp e
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0))
                            FROM emp
                            WHERE deptno = e.deptno
                            )
ORDER BY deptno ASC         ;                            

--해당 부서 20번의 maxpay와 같나?

-- emp 테이블의 전체 사원의 평균 급여
SELECT SUM(sal + NVL(comm, 0)) , COUNT(*) --사원수가 나옴
        ,ROUND (SUM(sal + NVL(comm, 0)) / COUNT(*), 2) avgpay
        ,ROUND (SUM(sal + NVL(comm, 0)) )avgpay
FROM emp;
--27125	12	2260.416666666666666666666666666666666667
-- emp 테이블에서 각 사월드이 평균급여보다 많이 받는 사원 정보를 조회
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE sal + NVL(comm, 0) > (SELECT AVG(sal + NVL(comm, 0)) FROM emp);
WHERE sal + NVL(comm, 0) > 2260.42

-- [문제]
SELECT AVG(sal + NVL(comm, 0)) FROM emp WHERE deptno=10;
--10번 부서원들의 평균 급여 : 2916.666666666666666666666666666666666667
SELECT AVG(sal + NVL(comm, 0)) FROM emp WHERE deptno=20;
--20번 부서원들의 평균 급여 : 2258.333333333333333333333333333333333333
SELECT AVG(sal + NVL(comm, 0)) FROM emp WHERE deptno=30;
--30번 부서원들의 평균 급여 : 1933.333333333333333333333333333333333333

-- 해당 부서의 평균보다 급여가 많으면 출력하는 쿼리를 작성 
SELECT deptno, ename, sal + NVL(comm, 0) pay
    ,(SELECT AVG(sal + NVL(comm, 0))
    FROM emp
    WHERE deptno = e.deptno)
FROM emp e
WHERE sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0))
                            FROM emp
                            WHERE deptno = e.deptno)
ORDER BY deptno ASC, pay ASC         ; 

--(2)
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0))   FROM emp WHERE deptno = 10) AND deptno = 10
UNION
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0))   FROM emp WHERE deptno = 20) AND deptno = 20                    
UNION
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0))   FROM emp WHERE deptno = 30) AND deptno = 30;
--10	KING	5000
--20	FORD	3000
--30	BLAKE	2850

--[문제] 부서번호, [부서명 만들어야함], 사원번호, 사원명, 입사일자 조회 - 조인(JOIN)★
SELECT deptno, empno, ename, hiredate
FROM emp;
--DESC emp;
SELECT deptno, dname, loc
FROM dept;
-- emp, detp 테이블 결합(join) + WHERE 조건절을 사용해서 조인 조건만들기
SELECT emp.deptno, empno, ename, hiredate
FROM emp, dept
WHERE emp.deptno= dept.deptno;
--ORA-00918: column ambiguously defined
SELECT e.deptno, d.dname, e.empno, e.ename, e.hiredate
FROM emp e
INNER JOIN dept d ON e.deptno = d.deptno; 
-- 관계형 데이터 모델
-- [테이블] 관계 [테이블]
-- 정규화 작업을 해서 중복된 자료는 뺀다
사원(EMP) 테이블 --DB 모델 이라고 함
사원번호 사원명 입사일자 부서번호 부서명 job 직급 부서내선번호 ... 부서장
8972    홍길동     97      10  영업부 점   대리    101         권태정
8972    홍길동     97      10  영업부 점   대리    101         권태정
8972    홍길동     97      10  영업부 점   대리    101         권태정
8972    홍길동     97      10  영업부 점   대리    101         서주원
8972    홍길동     97      10  영업부 점   대리    101         권태정
8972    홍길동     97      10  영업부 점   대리    101         권태정
8972    홍길동     97      10  영업부 점   대리    101         권태정
정규화 과정
[사원테이블]                     참조키(외래키) FK
PK
사원번호 사원명 입사일자  잡 직급 부서번호 (부서테이블의 부서번호 참조)
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 
 8972   홍길동 97//    점 대리 

[부서테이블] 부모테이블
PK
부서번호 부서명 부서장    내선번호 
10      영업부 서주원     101
20      총무부 김승효     102
:

--- 5일차 수업 시작 ---
--[SET(집합) 연산자]
-- 1) UNION / UNION ALL 연산자 (합집합)
--ORA-00937: not a single-group group function
SELECT name, city, buseo
--,COUNT(*)
FROM insa
WHERE buseo = '개발부'; --14명

--UNION     
UNION ALL 중복 O

SELECT name, city, buseo 
--,COUNT(*)
FROM insa
WHERE city = '인천'; --9 명    14+9 = 23   17명

SELECT COUNT(*)
FROM insa
WHERE city = '인천'; AND  buseo = '개발부'; --6 명

--(주의사항)
SELECT ename, hiredate, null gender
FROM emp
UNION
SELECT name, ibsadate, SUBSTR(ssn, -7, 1) gender
FROM insa;

--[문제] emp
--      UNION
--      insa
--      사원명, 입사일자, 부서명

--(1)
SELECT name, ibsadate, buseo
FROM insa
UNION
SELECT ename, hiredate, dname --,TO_CHAR(deptno)
FROM emp e, detp d
WHERE e.deptno = d.deptno;

--(2)
SELECT ename, hiredate, (SELECT dname FROM dept WHERE deptno = e.deptno) dname
FROM emp e
UNION
SELECT name, ibsadate, buseo
FROM insa i;
--

-----------------------------------------------------
SELECT ename AS 사원명, hiredate AS 입사일자, 'emp' AS 테이블구분, CAST(NULL AS VARCHAR2(20)) as 부서명
FROM emp

UNION ALL

SELECT name AS 사원명, ibsadate AS 입사일자, 'insa' AS 테이블구분, BUSEO as 부서명
FROM insa;
-----------------------------------------------------
-- INTERSECT (교집합)
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부';
INTERSECT -- 개발부인 동시엔 인천 사는 사원 정보
SELECT name, city, buseo
FROM insa
WHERE city = '인천'; AND  buseo = '개발부';

-- MINUS (차집합)
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '인천'; AND  buseo = '개발부';

-----------------------------------------------------
--[계층적 질의 연산자]
PRIOR, CONNECT_BY_ROOT 연산자
-----------------------------------------------------
--[오라클 함수]
-- 복잡한 쿼리문을 간단하게 해주고, 데이터의 값으 [조작]하는데 사용되는 것
-- 자바 : 주민등록번호 입력받아서 → 나이를 계산해서 반환 (코딩)
SELECT name, ssn
        ,UF_AGE(ssn, 0) 만나이 -- PL/SQL   사용자 정의 함수 uf_age()
        ,UF_AGE(ssn, 1) 세는나이
FROM insa;
-----------------------------------------------------
-- [오라클의 함수 : 단일행 함수, 복수행 함수]

-- 복수행 함수
SELECT COUNT (ename)
FROM emp;
-- 단일행 함수
SELECT LOWER (ename)
FROM emp;

--ORA-00937: not a single-group group function
SELECT LOWER (ename), COUNT (ename)
FROM emp;       --같이 사용 하면 안된다
--
SELECT ename, (SELECT COUNT(ename) FROM emp)
FROM emp;
-----------------------------------------------------
-- [숫자 함수]
SELECT SIGN (123), SIGN(-10 ), SIGN(0)
FROM dual;

SELECT ename, sal + avgpay, SIGN(pay - avgpay)
FROM (
        SELECT ename, sal + NVL(comm, 0) pay
        , ( SELECT AVG (sal + NVL(comm, 0) FROM emp) avgpay
        FROM emp
)e;
WHERE SIGN(pay - avgpay) = 1;
-----------------------------------------------------
SELECT POWER(2,3), POWER(2,-3)
        , SQRT(4), SQRT(2)
FROM dual;
-----------------------------------------------------
--[문자 함수]
SELECT UPPER('Admin'), LOWER('Admin'), INITCAP('admin')
FROM dual;
-----------------------------------------------------
-- 문자열 길이
SELECT DISTINCT CONCAT ( SUBSTR (job, 1, 3) || '...', LENGTH(job) )
FROM emp;
-----------------------------------------------------
-- 지정된 문자값 반환
-- ename 이름 속에 'I' 문자가 있는 위치 파악
SELECT ename
    ,INSTR(ename, 'I')
    ,INSTR(ename, 'AM')
FROM emp;

SELECT
    'ABCDEABCDEABCDE' AS original_string,
    INSTR('ABCDEABCDEABCDE', 'C', 1, 2) AS second_c,
    INSTR('ABCDEABCDEABCDE', 'C', -1 2) AS c_from_5th,
    INSTR('ABCDEABCDEABCDE', 'C', -1, 1) AS c_from_end,
     INSTR('ABCDEABCDEABCDE', 'C', -1, 2) AS second_c_from_end
FROM dual;
-----------------------------------------------------
SELECT *
FROM tbl_tel;
--[문제] 지역번호만 뽑아와서 출력. (02, 031, 051)

SELECT tel
    , INSTR( tel, ')' )
    , INSTR( tel, '-' )
    , SUBSTR(tel, 1, INSTR( tel, ')' )-1 )  지역번호
    , SUBSTR(tel, INSTR( tel, ')' )+1,  INSTR( tel, '-' ) - INSTR( tel, ')' )-1      )  앞전번
    , SUBSTR(tel, INSTR( tel, ')' )+1,  INSTR( tel, '-' ) - INSTR( tel, ')' )-1      )  앞전번 SUBSTR(tel, INSTR( tel, '-' )+1     )  뒷전번
FROM tbl_tel;

--(2) 풀이
SELECT tel
    ,REGEXP_REPLACE(tel, '(\d+)\)(\d+)-(\d+)', '\1')
    ,REGEXP_REPLACE(tel, '(\d+)\)(\d+)-(\d+)', '\2')
    ,REGEXP_REPLACE(tel, '(\d+)\)(\d+)-(\d+)', '\3')
FROM tbl_tel;

-----------------------------------------------------
--RPAD(), LPAD()
SELECT empno, ename || '' || hiredate
FROM emp;
---
SELECT empno
     , LENGTH( ename )
     , LENGTH( hiredate )
     , RPAD( ename  , (SELECT MAX( LENGTH(ename)  ) + 3 FROM emp) , ' ' ) || hiredate
FROM emp;

SELECT MAX( LENGTH(ename)  ) + 3 FROM emp;
--
SELECT
    LPAD(empno, 10) AS empno,
    LPAD(ename, 15) AS ename,
    hiredate
FROM emp;
--
SELECT
    RPAD(empno, 10) AS empno,
    RPAD(ename, 15) AS ename,
    hiredate
FROM emp;
-----------------------------------------------------
SELECT select RTRIM('BROWING: ./=./=./=./=.=/.=', '/=.') "RTRIM example" 
FROM dual;

SELECT RPAD(sal, 10, '*')
    ,REPLACE(RPAD(sal, 10, '*'), '*')
    ,RTRIM(RPAD(sal, 10, '*'), '*')
FROM emp;

--[문제] RTRIM(), LTRIM(), TRIM()
-- 형식 : TRIM([trim_char_FROM] string)
SELECT '   ADMIN    ' AS trim,  -- 문자열 앞뒤의 공백을 제거 하는 쿼리 작성
    ,'[' || RTRIM(LTRIM('   ADMIN    ',' ') || ']'
    ,'[' || TRIM(LTRIM('   ADMIN    ',' ') || ']'
    ,'[' || TRIM(FROM('***ADMIN****') || ']'
FROM dual;
-----------------------------------------------------
SELECT ASCII ('A'), ASCII('0')
    ,CHR(65),       CHR(48)
FROM dual;
-----------------------------------------------------
--GREATEST / LEAST
SELECT GREATEST(1,2,3,4,5), GREATEST('a','b','A','B','z')
    ,LEAST(1,2,3,4,5) LEAST('a','b','A','B','z')
FROM dual;
-----------------------------------------------------
SELECT VSIZE('A'), VSIZE('한'), VSIZE(1)
FROM daul;

SELECT dname
    ,LENGTH (dname)
    ,VSIZE(dname) || 'bytes'
FROM dept;

SELECT name
        ,LENGTH (name)
        ,LENGTH (name) || '(bytes)'
FROM insa
WHERE num < 1005;
-----------------------------------------------------
--[날짜 함수]
-- [SYSDATE 함수] 날짜 + 시간,분,[초]
-- 2025.03.21 (금) 00:00:00 
SELECT SYSDATE AS time,
    TO_CHAR(SYSDATE, 'YYYY.MM.DD (DY) HH24:MI:SS') AS formatted_time
FROM dual;

-----------------------------------------------------

