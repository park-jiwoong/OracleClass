-- SCOTT --
SELECT * 
FROM emp;

--  1)  미리정의된 에러처리방법 
CREATE OR REPLACE PROCEDURE up_exception_test
(
   psal IN emp.sal%TYPE
)
IS
  vename emp.ename%TYPE;
BEGIN
  SELECT ename INTO vename
  FROM emp
  WHERE sal = psal;
  DBMS_OUTPUT.PUT_LINE('> ename = ' || vename);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;
-- Procedure UP_EXCEPTION_TEST이(가) 컴파일되었습니다.

EXECUTE UP_EXCEPTION_TEST(800);  -- 1

-- ORA-01403. 00000 -  "no data found"
EXECUTE UP_EXCEPTION_TEST(9000);

-- ORA-01422: exact fetch returns more than requested 
--            number of rows
EXECUTE UP_EXCEPTION_TEST(2850);

-- 2) 미리 정의되지 않은 에러 처리방법 
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated -
-- parent key not found
INSERT INTO emp ( empno, ename, deptno ) 
VALUES ( 9999, 'admin', 90 );
-- 
CREATE OR REPLACE PROCEDURE up_insert_emp
(
      pempno emp.empno%TYPE
    , pename emp.ename%TYPE
    , pdeptno emp.deptno%TYPE
)
IS
   PARENT_KEY_NOT_FOUND EXCEPTION;
   PRAGMA EXCEPTION_INIT(PARENT_KEY_NOT_FOUND, -02291);
BEGIN
  INSERT INTO emp ( empno, ename, deptno ) 
  VALUES ( pempno, pename, pdeptno );  
  COMMIT;
EXCEPTION
  -- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated -
  WHEN PARENT_KEY_NOT_FOUND THEN
     RAISE_APPLICATION_ERROR(-20011, '> QUERY FK violated.');
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;

EXECUTE UP_INSERT_EMP( 9000, 'admin', 40 );
EXECUTE UP_INSERT_EMP( 9000, 'admin', 90 );

SELECT * 
FROM emp;
--
DELETE FROM emp
WHERE empno >= 9000;
COMMIT;

-- 3) 사용자가 정의한 에러 처리방법 ( 프로젝트 진행 )
--자바 수업 
-- 필드
-- private int kor;
-- 
-- setter
-- 0~100 점수 -> kor = ??
-- !0~100      throw new ScoreOutOfBoundException(1001,'국어점수범위~');
-- 
-- -- 사용자 예외 클래스 선언
-- class ScoreOutOfBoundException extends Exception{
-- }
 
EXEC up_user_exception(  800, 1200 ); 
EXEC up_user_exception(  6000, 7000 );  -- X
-- 만약에 losal ~ hisal 범위 사이의 사원이 존재하지 않으면 강제로 
-- 사용자 예외 발생시켜서 예외 처리하도록 하겠습니다.
CREATE OR REPLACE PROCEDURE up_user_exception
(
      plosal NUMBER
    , phisal NUMBER
)
IS
   vcount NUMBER;
   -- 1) 사용자 정의 예외 객체(변수)를 선언
   ZERO_EMP_COUNT EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO vcount
  FROM emp
  WHERE sal BETWEEN plosal AND phisal;
  
  IF vcount = 0 THEN
    -- 강제로 예외를 발생시킨다.
    RAISE ZERO_EMP_COUNT;
  ELSE
     DBMS_OUTPUT.PUT_LINE( '> 사원수 : ' || vcount ); 
  END IF;
  
EXCEPTION
  WHEN  ZERO_EMP_COUNT THEN
      RAISE_APPLICATION_ERROR(-20022, '> 범위의 사원수가 0 이다.'); 
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;

-- Procedure UP_USER_EXCEPTION이(가) 컴파일되었습니다.

-- 4)
CREATE OR REPLACE PROCEDURE test7
(v_sal  IN emp.sal%TYPE)
IS
 v_ename        emp.ename%TYPE;
 v_err_code     number;
 v_err_message  varchar(255);

begin
 select ename into v_ename from emp
  where sal = v_sal;
   dbms_output.put_line('He is ' || v_ename  || '....');

exception
 WHEN no_data_found THEN
   v_err_code    := SQLCODE;
   v_err_message := SQLERRM;
   dbms_output.put_line(v_err_code  || '   '  || v_err_message);
 WHEN too_many_rows THEN
   raise_application_error(-2003, 'Too Many Rows...');
 WHEN others        THEN
   raise_application_error(-2004, 'Others Error...');
END;

execute test7(9000);



