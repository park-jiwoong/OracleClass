-- [문제] 30번 부서원들 중에 최고 급여(pay)를 받는 사원의 정보를 출력하는 쿼리 작성
--(empno, ename, hiredate, job, sal, comm)
-- 1) PL/SQL X
-- a. TOP-N 방식
SELECT *
FROM(
    select empno, ename, hiredate, job, sal, comm
    from emp
    where deptno = 30
    order by sal+nvl(comm, 0) desc
)
WHERE ROWNUM = 1;

-- b.RANK 함수

SELECT *
FROM (
    select empno, ename, hiredate, job, sal, comm
        ,rank() over(order by sal+nvl(com, 0)desc)
    from emp
    where deptno = 30
    )
WHERE ROWNUM = 1;


-- c.서브쿼리
SELECT *
FROM emp
WHERE deptno = 30
    AND sal = (
        SELECT MAX(sal)
        FROM emp
        WHERE deptno = 30
        );
--

SELECT e.*
FROM (
    select empno, ename, hiredate, job, sal, comm
        ,max(sal) over(partition by deptno) maxsal
    from emp
    where deptno = 30
)e
WHERE sal = maxsal;

--------------------------------------------------------------------------------
--PL/SQL

select * from insa;SELECT *
FROM (
    select empno, ename, hiredate, job, sal, comm
        ,rank() over(order by sal+nvl(comm, 0)desc)
    from emp
    where deptno = 30
    )
WHERE ROWNUM = 1;

desc emp;

DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6); --byte 자료형 오류
BEGIN
    vnum := :bindNumber; -- 바인드변수
    IF mod(vnum, 2) = 0 THEN vresult := '짝수';
    ELSE vresult := '홀수';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);

--EXCEPTION
END;




