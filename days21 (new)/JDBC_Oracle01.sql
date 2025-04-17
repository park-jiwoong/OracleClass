-- 2025.04.16 (수) 
-- 회원테이블에서 아이디 중복체크하는 저장 프로시저 선언
-- (emp 테이블 empno(아이디) )
CREATE OR REPLACE PROCEDURE up_idcheck
(
    pid IN  emp.empno%TYPE -- empno
    , pcheck OUT NUMBER -- 0(사용가능) / 1(사용중) 반환
)
IS
BEGIN
    SELECT COUNT(*) INTO pcheck
    FROM emp
    WHERE empno = pid;
--EXCEPTION
END;

--Procedure UP_IDCHECK이(가) 컴파일되었습니다.
-- 반드시 테스트
DECLARE
    vcheck NUMBER(1);
BEGIN
    UP_IDCHECK( 9999, vcheck );
    DBMS_OUTPUT.PUT_LINE(vcheck);
END;

----------- days03 Ex07 -----------
CREATE OR REPLACE PROCEDURE up_login (
    pid IN emp.empno%TYPE,
    ppw IN emp.ename%TYPE,
    pcheck OUT NUMBER
)
IS
    vExists NUMBER;
BEGIN
    -- ID가 존재하는지 먼저 확인
    SELECT COUNT(*) INTO vExists FROM emp WHERE empno = pid;

    IF vExists = 0 THEN
        pcheck := -1; -- 아이디 없음
    ELSE
        -- 그 다음 비밀번호(ename) 확인
        SELECT COUNT(*) INTO pcheck
        FROM emp
        WHERE empno = pid AND ename = ppw;
    END IF;

--EXCEPTION

END;
-- Procedure UP_IDCHECK이(가) 컴파일되었습니다.
-- 반드시 테스트 
DECLARE
    vcheck NUMBER(1);
BEGIN
    UP_LOGIN( 7369, 'SMITH', vcheck );
    DBMS_OUTPUT.PUT_LINE(vcheck);
END;

select * from emp;
---------- days03 Ex02 ---------
/* 커서 선언 4단계
명시 - 커서오픈 - 패치 - 클로즈
CREATE OR REPLACE PROCEDURE up_selectdept
(
    pdeptcursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pdeptcursor FOR
        select *
        from dept;
--EXCEPTION
END;
--Procedure UP_SELECTDEPT이(가) 컴파일되었습니다.
*/

----------Ex02_02 up_insertdept -----------------
CREATE OR REPLACE PROCEDURE up_insertdept
(
    pdname dept.dname%TYPE := NULL
    , ploc dept.loc%TYPE := NULL
)
IS
    vdeptno dept.deptno%TYPE;
BEGIN
    SELECT NVL(MAX(deptno), 0)+ 10 INTO vdeptno
    FROM dept;
    
    INSERT INTO dept VALUES ( vdeptno, pdname, ploc);
    COMMIT;
--EXCEPTION
END;

--Procedure UP_INSERTDEPT이(가) 컴파일되었습니다.


select * from dept;

-------- Ex02_03 delete -----------
CREATE OR REPLACE PROCEDURE up_deletdept
(
    pdeptno dept.dname%TYPE
)
IS
BEGIN
    delete from dept
    where deptno = pdeptno;
    commit;
--EXCEPTION
END;
--Procedure UP_DELETDEPT이(가) 컴파일되었습니다.


-------- Ex02_04 up_updatedept -----------
CREATE OR REPLACE PROCEDURE up_updatedept
(
    pdeptno dept.dname%TYPE
)
IS
BEGIN
    delete from dept
    where deptno = pdeptno;
    commit;
--EXCEPTION
END;

--------Ex02_05
CREATE OR REPLACE PROCEDURE up_updatedept
(
    pdeptno  dept.deptno%TYPE  
    , pdname dept.dname%TYPE := NULL
    , ploc dept.loc%TYPE := NULL
)
IS 
BEGIN   
   UPDATE dept
   SET dname = NVL( pdname, dname), loc = NVL(ploc, loc)
   WHERE deptno = pdeptno;
   COMMIT;
-- EXCEPTION
END;
