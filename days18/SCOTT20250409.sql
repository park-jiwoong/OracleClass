-- SCOTT --

-- [동적쿼리] --------------------------------------------------------------------

--자바 수업 - 동적 배열
--int [] m = null;
--int size = scanner.nextInt();
--m - new int[size];

-- [동적 쿼리] ? 쿼리 (SQL) 미완성
-- ex) 다나와 사이트 : 노트북 검색
-- 검색 조건에 체크한 갯수 만큼
-- SELECT
-- WHERE 체크한 만큼...

-- [동적 쿼리(SQL)을 사용하는 경우 3가지]
--1) 컴파일 시에 SQL문장이 확정되지 않은 경우 (가장 많이 사용되는 경우)
--WHERE 조건절... X
--
--2) PL/SQL 블럭 안에서 DDL문을 사용하는 경우
-- CREATE, DROP, ALTER 문
--
--3) PL/SQL 블럭 안에서 ALTER SYSTEM/SESSION 명령어를 사용하는 경우

-- [PL/SQL 동적 쿼리를 사용하는 방법 2가지]
--1) DBMS_SQL 패키지
--2) EXECUTE IMMDIATE 문
--언제 사용 했는지? -> SELECT ename INTO vename 변수에 값을 할당


--구문 형식)
EXECUTE[UTE] IMMEDIATE 동적쿼리문
    [INTO 변수명, 변수명...]
    [USING IN / OUT / IN 파라미터, 파라미터,,,]
    
-- 실습 예제 ---------------------------------------------------------------------
-- 익명 PROCEDURE
DECLARE
    vsql VARCHAR2(1000); -- 동적쿼리문
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
    vsql := vsql || 'WHERE empno = 7369';
    
    DBMS_OUTPUT.PUT_LINE(vsql);
    
    EXECUTE IMMEDIATE vsql
        INTO vdeptno, vempno, vename, vjob;
        
    dbms_output.put_line(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);
--EXCEPTION
END;

-------------------------------------------------------------------------------
-- 예)
CREATE OR REPLACE PROCEDURE up_ds_emp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000); -- 동적쿼리문
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
    vsql := vsql || 'WHERE empno = ' || pempno;
    
    DBMS_OUTPUT.PUT_LINE(vsql);
    
    EXECUTE IMMEDIATE vsql
        INTO vdeptno, vempno, vename, vjob;
        
    dbms_output.put_line(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);
--EXCEPTION
END;

EXECUTE UP_DS_EMP(7369);
-- 예 2)------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE up_ds_emp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000); -- 동적쿼리문
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
    vsql := vsql || 'WHERE empno = :pempno';
    
    DBMS_OUTPUT.PUT_LINE(vsql);
    
    EXECUTE IMMEDIATE vsql
        INTO vdeptno, vempno, vename, vjob
        USING IN pempno;
        
    dbms_output.put_line(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);
--EXCEPTION
END;

EXECUTE UP_DS_EMP(7369);

-- 예) 동적 쿼리를 사용해서 dept 테이블에 부서를 추가 ---------------------------------
CREATE OR REPLACE PROCEDURE up_ds_insert_dept
(
    pdname dept.dname%TYPE := NULL 
    ,ploc dept.loc%TYPE := NULL
)
IS
    vsql VARCHAR2(1000); -- 동적쿼리문
    vdeptno dept.deptno%TYPE;
   
BEGIN
    SELECT MAX(NVL(deptno, 0)) + 10 INTO vdeptno 
    FROM dept;
    
    vsql := 'INSERT INTO dept (deptno, dname, loc) ';
    vsql := vsql || 'VALUES(:vdeptno, :pdname, :ploc) ';
    
    DBMS_OUTPUT.PUT_LINE(vsql);
    
    EXECUTE IMMEDIATE vsql
        USING IN vdeptno, pdname, pdname, ploc;
    -- COMMIT;
    dbms_output.put_line('INSERT 성공~' );
--EXCEPTION
END;

--19/5      PL/SQL: Statement ignored
--20/18     PLS-00201: identifier 'VDETPNO' must be declared
--오류: 컴파일러 로그를 확인하십시오.

EXECUTE up_ds_insert_dept('QC ', 'SEOUL ');
ROLLBACK;
SELECT * FROM dept;


-- 예) 동적 쿼리 - (테이블을 동적으로 생성하는 DDL문 사용)------------------------------
DECLARE -- 익명PROCEDURE
    vsql VARCHAR2(1000); -- 동적쿼리문
    vtableName VARCHAR2(20);
BEGIN
    vtableName := 'TBL_DS_SAMPLE';
    
    vsql := 'CREATE TABLE ' || vtableName || ' ';
    vsql := vsql || '(' ;
    vsql := vsql || ' id NUMBER PRIMARY KEY ' ;
    vsql := vsql || ' ,name VARCHAR2(20) ' ;
    vsql := vsql || ' ,age NUMBER(3) ' ;
    vsql := vsql || ')';

    
    DBMS_OUTPUT.PUT_LINE(vsql);
    
    EXECUTE IMMEDIATE vsql;
    -- COMMIT;
    dbms_output.put_line('동적 테이블 생성 성공~' );
--EXCEPTION
END;

--오류 발생 행: 19:
--ORA-06550: line 19, column 5:
--PLS-00103: Encountered the symbol "DBMS_OUTPUT" when expecting one of the following:

EXECUTE up_ds_insert_dept('QC', 'SEOUL');
ROLLBACK;
SELECT * FROM dept;

-- *** 동적 쿼리 INSERT / UPDATE / DELETE ---------------------------------------
-- 동적 쿼리 SELECT
-- [ 동적쿼리 SELECT 여러 개의 행을 조회...]
-- 사원테이블에서 부서번호를 파라미터로 SELECT
CREATE OR REPLACE PROCEDURE up_ds_select_emp
(
    pdeptno emp.deptno%TYPE
)
IS
    vsql VARCHAR2(1000); -- 동적쿼리문
    vrow emp%ROWTYPE;
    vcursor SYS_REFCURSOR; -- 9i REF CURSOR (9i ~ 이후부터는 자료형 이렇게 선언)
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || 'FROM emp ';
    vsql := vsql || 'WHERE deptno = :pdeptno ';
    
    DBMS_OUTPUT.PUT_LINE(vsql);
    
-- EXECUTE IMMEDIATE 동적쿼리문; DML + SELECT 1행

-- PL/SQL 여러 개의 행 처리 : 커서(CURSOR)
-- OPEN ~ FOR문 사용
-- OPEN 커서명 FOR 동적쿼리 USING 파라미터; (구문 형식)
OPEN vcursor FOR vsql USING pdeptno;

LOOP
    FETCH vcursor INTO vrow;
    EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vrow.empno || ' , ' || vrow.ename );

END LOOP;

CLOSE vcursor;

    dbms_output.put_line('SELECT 성공~' );
-- COMMIT;
--EXCEPTION
END;

EXECUTE up_ds_select_emp(30);

-- emp 테이블에서 검색 기능 구현 ---------------------------------------------------
-- 1) 검색조건    : 1 부서번호, 2 사원명, 3 잡
-- 2) 검색어      : [     ]
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
  psearchCondition NUMBER -- 1. 부서번호, 2.사원명, 3. 잡
  , psearchWord VARCHAR2
)
IS
  vsql  VARCHAR2(2000);
  vcur  SYS_REFCURSOR;   -- 커서 타입으로 변수 선언  9i  REF CURSOR
  vrow emp%ROWTYPE;
BEGIN
  vsql := 'SELECT * ';
  vsql := vsql || ' FROM emp ';
  
  IF psearchCondition = 1 THEN -- 부서번호로 검색
    vsql := vsql || ' WHERE  deptno = :psearchWord ';
  ELSIF psearchCondition = 2 THEN -- 사원명
    vsql := vsql || ' WHERE  REGEXP_LIKE( ename , :psearchWord )';    
  ELSIF psearchCondition = 3  THEN -- job
    vsql := vsql || ' WHERE  REGEXP_LIKE( job , :psearchWord , ''i'')';
  END IF; 
   
  OPEN vcur  FOR vsql USING psearchWord;
  LOOP  
    FETCH vcur INTO vrow;
    EXIT WHEN vcur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( vrow.empno || ' '  || vrow.ename || ' ' || vrow.job );
  END LOOP;   
  CLOSE vcur; 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
  WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR...');
END;

EXEC UP_NDSSEARCHEMP(1, '20'); 
EXEC UP_NDSSEARCHEMP(2, 'L'); 
EXEC UP_NDSSEARCHEMP(3, 's'); 
