-- SCOTT --  
-- [문제] WHILE문 사용  구구단 2~9단 ( 가로 )
--DECLARE 
BEGIN
  FOR vi IN 1..9 LOOP
    FOR vdan IN 2..9 LOOP
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' '));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');  -- 개행
  END LOOP;     
--EXCEPTION
END;
-- [문제] WHILE문 사용  구구단 2~9단 ( 세로 )
DECLARE
  vdan NUMBER(2) := 2 ;
  vi NUMBER := 1;
BEGIN
  WHILE vdan <= 9 LOOP
    vi := 1;
    WHILE vi <= 9 LOOP
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' '));
      vi := vi + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
     vdan := vdan + 1;
  END LOOP;
--EXCEPTION
END;

-- [문제] FOR문 사용  구구단 2~9단 ( 가로 )
-- [문제] FOR문 사용  구구단 2~9단 ( 세로 )
--DECLARE 
BEGIN
  FOR vdan IN 2..9 LOOP
    FOR vi IN 1..9 LOOP
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' '));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');  -- 개행
  END LOOP;     
--EXCEPTION
END;
-- [문제] emp 테이블에서 10번 부서원 20% 인상, 20번 부서원10% 인상, 
-- 그 외 부서는 15% 인상 ... 
-- PL/SQL의 익명 프로시저 작성해서 처리 
--DECLARE
BEGIN
  UPDATE emp
  SET sal = DECODE(deptno, 10, sal * 1.2, 20, sal * 1.1, sal * 1.15);
  /*
  SET sal = CASE deptno 
              WHEN 10 THEN sal * 1.2
              WHEN 20 THEN sal * 1.1
              ELSE sal * 1.15
            END;
   */         
--EXCEPTION
END;
-- 
ROLLBACK;
SELECT * 
FROM emp;

-- [ FOR문 사용해서 SELECT  ]
DECLARE
   vename VARCHAR2(10);
   vhiredate emp.hiredate%TYPE;
   -- vrow emp%ROWTYPE;
BEGIN
   SELECT ename, hiredate INTO vename, vhiredate
   FROM emp
   WHERE empno = 7369;
   
   DBMS_OUTPUT.PUT_LINE( vename || ', ' || vhiredate );
-- EXCEPTION
END;

-- 커서 : 암(묵)시적 커서
DECLARE
   vename VARCHAR2(10);
   vhiredate emp.hiredate%TYPE;
   -- vrow emp%ROWTYPE;
BEGIN
--   [2]
     FOR vrow IN (  SELECT ename, hiredate, job  FROM emp )
     LOOP
        DBMS_OUTPUT.PUT_LINE( vrow.ename || ', ' || vrow.hiredate 
        || ', ' || vrow.job );
     END LOOP;

   /* [1] 커서(CURSOR) - 암/명
   SELECT ename, hiredate INTO vename, vhiredate
   FROM emp;
--   WHERE empno = 7369;
   
   DBMS_OUTPUT.PUT_LINE( vename || ', ' || vhiredate );
   */
-- EXCEPTION
END;
-- ORA-01422: exact fetch returns more than requested number of rows

-- [사용자 정의 구조체 타입 선언 ] 예제.
-- 1) %TYPE 변수 
DECLARE
  vdeptno dept.deptno%TYPE;
  vdname dept.dname%TYPE;
  vempno emp.empno%TYPE;
  vename emp.ename%TYPE;
  vpay NUMBER;
BEGIN
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     INTO vdeptno, vdname, vempno, vename, vpay
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
   DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || vdname  
    || ', ' ||  vempno  || ', ' || vename  || ', ' ||  vpay );
--EXCEPTION
END;
-- 2) %ROWTYPE 변수
DECLARE
  vdrow dept%ROWTYPE;
  verow emp%ROWTYPE;
  vpay NUMBER;
BEGIN
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay 
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
   DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
    || ', ' ||  verow.empno  || ', ' || verow.ename  || ', ' ||  vpay );
--EXCEPTION
END;
-- 3) 사용자 정의 구조체 타입 -> 사용
DECLARE
  -- ㄱ. 사용자 정의 구조체 타입 선언
  TYPE EmpDeptType IS RECORD
  (
     deptno dept.deptno%TYPE,
     dname dept.dname%TYPE,
     empno emp.empno%TYPE,
     ename emp.ename%TYPE,
     pay NUMBER
  );

  -- ㄴ. 변수 선언
  vrow EmpDeptType;
BEGIN
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     INTO vrow.deptno, vrow.dname, vrow.empno, vrow.ename, vrow.pay 
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
   DBMS_OUTPUT.PUT_LINE( vrow.deptno || ', ' || vrow.dname 
    || ', ' ||  vrow.empno  || ', ' || vrow.ename  || ', ' ||  vrow.pay );
--EXCEPTION
END;

-- [문제] insa 테이블에서 사원번호(num)=1001
--  급여 파악 -> 2500000 많으면 세금을 2.5%,   2000000 많으면 2%
--              0% 출력..
DECLARE
  vname insa.name%TYPE;
  vpay NUMBER;
  vtax NUMBER;
  vsil NUMBER; -- vpay - vtax;
BEGIN
  SELECT name, basicpay + sudang 
     INTO vname, vpay
  FROM insa
  WHERE num = 1001;
  
  IF vpay >= 2500000 THEN
     vtax := vpay * 0.025;
  ELSIF vpay >= 2000000 THEN
    vtax := vpay * 0.02;
  ELSE
    vtax := 0;
  END IF;  
  -- 실수령액
  vsil := vpay - vtax;  
   DBMS_OUTPUT.PUT_LINE(vname || '   ' || vpay || '   ' 
   || vtax || '   ' || vsil);  
--EXCEPTION
END;

-- [커서(cursor)] --
-- 1.  명시적 커서 사용 예제
DECLARE 
  TYPE EmpDeptType IS RECORD
  (
     deptno dept.deptno%TYPE,
     dname dept.dname%TYPE,
     empno emp.empno%TYPE,
     ename emp.ename%TYPE,
     pay NUMBER
  ); 
  vrow EmpDeptType;
  -- ㄱ. 커서 선언
  -- CURSOR 커서명 IS (SELECT문);
  CURSOR vdecursor IS (
      SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay     
      FROM dept d JOIN emp e ON d.deptno = e.deptno
  );
BEGIN
   -- ㄴ. OPEN : SELECT문 실행.
   OPEN vdecursor;
   -- ㄷ. FETCH : 가져오다 -> 반복적으로 처리...
   LOOP
     DBMS_OUTPUT.PUT_LINE('> 읽어온 레코드 수 : ' || vdecursor%ROWCOUNT);
     FETCH vdecursor INTO vrow;
     EXIT WHEN vdecursor%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE( vrow.deptno || ', ' || vrow.dname 
    || ', ' ||  vrow.empno  || ', ' || vrow.ename  || ', ' ||  vrow.pay );
   END LOOP;
   -- ㄹ. CLOSE
   CLOSE vdecursor;
--EXCEPTION
END;

-- 2.  명시적 커서 사용 예제
--DECLARE  
BEGIN
   FOR vrow IN (
      SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay     
      FROM dept d JOIN emp e ON d.deptno = e.deptno
   )
   LOOP
      DBMS_OUTPUT.PUT_LINE( vrow.deptno || ', ' || vrow.dname 
    || ', ' ||  vrow.empno  || ', ' || vrow.ename  || ', ' ||  vrow.pay );
   END LOOP; 
--EXCEPTION
END;

-- 3.  명시적 커서 사용 예제
DECLARE  
  CURSOR vdecursor IS (
      SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay     
      FROM dept d JOIN emp e ON d.deptno = e.deptno
  );
BEGIN
   --OPEN vdecursor;
   FOR vrow IN vdecursor  
   LOOP
      DBMS_OUTPUT.PUT_LINE( vrow.deptno || ', ' || vrow.dname 
    || ', ' ||  vrow.empno  || ', ' || vrow.ename  || ', ' ||  vrow.pay );
   END LOOP; 
--EXCEPTION
END;

-- 저장 프로시저( Stored Procedure )
-- 저장 프로시저 선언 형식)
CREATE OR REPLACE PROCEDURE up프로시저명
(
 -- 매개변수 선언
   pssn      VARCHAR2,
   pename IN emp.ename%TYPE,  -- 입력용 매개변수
   pssn   OUT   VARCHAR2,  -- 출력용 매개변수  
   pssn   IN OUT   VARCHAR2,  -- 입,출력용 매개변수
)
IS 
 -- 변수, 상수 선언
  vname  VARChAR2(10):= '홍길동';
  vpay  NUMBER;
BEGIN
EXCEPTION
END;

-- 저장 프로시저를 실행하는 방법( 3가지 ) 
-- 1) EXEC[UTE] 문으로 실행.
-- 2) 익명 프로시저에서 호출해서 실행
-- 3) 또 다른 저장 프로시저에서 호출해서 실행

--  [문제] emp 복사 -> tbl_emp 테이블 생성( 구조복사 + 데이타 복사)
--   tbl_emp 에 사원번호를 입력받아서 사원을 삭제 쿼리 작성
--   사원 삭제하는 저장 프로시저 생성 + 처리.
-- 1) 
DROP TABLE tbl_emp PURGE;
CREATE TABLE tbl_emp
AS
 ( SELECT * FROM emp );
-- Table TBL_EMP이(가) 생성되었습니다.
-- 2) 
DELETE FROM tbl_emp
WHERE empno = 7369;
--
ROLLBACK;
--
SELECT * 
FROM tbl_emp;
-- 3) 
CREATE OR REPLACE PROCEDURE updeltblemp
(
 -- pempno IN NUMBER(4)
 -- pempno IN NUMBER
 -- pempno IN tbl_emp.empno%TYPE
  pempno tbl_emp.empno%TYPE
)
IS
   -- v변수 X
BEGIN
  DELETE FROM tbl_emp
  WHERE empno =  pempno;
  COMMIT;
--EXCEPTION
   -- ROLLBACK;
END;

-- 1 번째 실행 : EXECUTE문 사용.
EXECUTE updeltblemp(7369);
EXECUTE updeltblemp(7499);
-- 2 번째 실행 : 익명 프로시저에서 실행
--DECLARE
BEGIN
  updeltblemp(7521);
  COMMIT;
-- EXCEPTION
END;
-- 3 번째 실행 : 또 다른 저장 프로시저에서 실행.
CREATE OR REPLACE PROCEDURE upother
(
  pempno IN tbl_emp.empno%TYPE 
)
IS
BEGIN
   updeltblemp(pempno);
   COMMIT;
-- EXCEPTION
END;

EXECUTE upother( 7566 );

COMMIT;
--
SELECT * FROM tbl_emp;

-- [문제] dept -> tbl_dept 테이블 생성
--       CRUD   저장 프로시저 만들어서 테스트 
-- 1) 
DROP TABLE tbl_dept PURGE;
--
CREATE TABLE tbl_dept
AS
  ( SELECT * FROM dept );
-- 2) tbl_dept 테이블에 제약조건 확인
--    deptno 컬럼에 PK 제약조건을 추가.
SELECT * 
FROM user_constraints
WHERE table_name LIKE 'TBL_D%';
--
ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbl_dept_deptno PRIMARY KEY( deptno );
-- 3) tbl_dept 모든 레코드를 읽어와서 출력하는 SELECT~ : upselecttbldept
CREATE OR REPLACE PROCEDURE upselecttbldept
IS
   -- 1) 커서 선언
   CURSOR vdcursor IS ( SELECT deptno, dname, loc FROM tbl_dept );
   vdrow tbl_Dept%ROWTYPE;
BEGIN
   -- 2) OPEN
   OPEN vdcursor;
   -- 3) FETCH
   LOOP
      FETCH vdcursor INTO vdrow;
      EXIT WHEN vdcursor%NOTFOUND;
      DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
      DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
   END LOOP;
   -- 4) CLOSE
   CLOSE vdcursor;
--EXCEPTION
END;

-- FOR 2번째 방법으로 커서를 사용 코딩으로 수정.
CREATE OR REPLACE PROCEDURE upselecttbldept
IS
   -- 1) 커서 선언
   CURSOR vdcursor IS ( SELECT deptno, dname, loc FROM tbl_dept );
BEGIN 
   FOR vdrow IN vdcursor
   LOOP 
      DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
      DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
   END LOOP; 
--EXCEPTION
END;
--
EXECUTE UPSELECTTBLDEPT;

-- 2) INSERT :   upinserttbldept
-- 시퀀스 생성  40     50    60
【형식】
   CREATE SEQUENCE 시퀀스명
   [ INCREMENT BY 정수]
   [ START WITH 정수]
   [ MAXVALUE n ¦ NOMAXVALUE]
   [ MINVALUE n ¦ NOMINVALUE]
   [ CYCLE ¦ NOCYCLE]
   [ CACHE n ¦ NOCACHE];
--  tbl_Dept 테이블의 deptno 를 자동으로 입력하기 위한 시퀀스 생성.
CREATE SEQUENCE seq_tbl_dept
    INCREMENT BY 10
    START WITH  50
    MAXVALUE 90
    MINVALUE 10
    NOCYCLE 
    NOCACHE;
--    Sequence SEQ_TBL_DEPT이(가) 생성되었습니다. 
CREATE OR REPLACE PROCEDURE upinserttbldept
(
   pdname IN tbl_dept.dname%TYPE DEFAULT NULL,
   ploc IN   tbl_dept.loc%TYPE := NULL
)
IS
   --vdeptno tbl_Dept.deptno%TYE;
BEGIN
   --SELECT MAX(deptno) + 10 INTO vdeptno
   --FROM tbl_dept;

   INSERT INTO tbl_dept ( deptno, dname, loc )
   VALUES ( SEQ_TBL_DEPT.NEXTVAL, pdname, ploc );
   COMMIT;
-- EXCEPTION
END;
--
EXECUTE upinserttbldept( pdname=>'QC', ploc=>'SEOUL' );
EXECUTE upinserttbldept( pdname =>'QC2' );
EXECUTE upinserttbldept( ploc => 'POHANG' );
EXECUTE upinserttbldept;
--
SELECT * FROM tbl_dept;

-- [문제]  삭제할 부서번호를 입력받아서 해당 부서를 삭제하는 프로시저 생성
--     updeletetbldept
CREATE OR REPLACE PROCEDURE updeletetbldept
(
   pdeptno IN tbl_dept.deptno%TYPE 
)
IS 
BEGIN 
   DELETE FROM tbl_dept 
   WHERE deptno = pdeptno;
   COMMIT;
-- EXCEPTION
END;
-- Procedure UPDELETETBLDEPT이(가) 컴파일되었습니다
EXECUTE UPDELETETBLDEPT(80);
--
SELECT * FROM tbl_dept;

-- [문제] tbl_dept 테이블의 레코드 수정  upupdatetbldept
CREATE OR REPLACE PROCEDURE upupdatetbldept
(
     pdeptno tbl_dept.deptno%TYPE
   , pdname tbl_dept.dname%TYPE := NULL
   , ploc tbl_dept.loc%TYPE := NULL
)
IS
  vdname tbl_dept.dname%TYPE;
  vloc tbl_dept.loc%TYPE;
BEGIN 
   -- 1) 수정 전의 dname, loc 변수에 저장
    SELECT dname, loc INTO vdname, vloc
    FROM tbl_dept
    WHERE deptno = pdeptno;

    IF pdname IS NULL THEN
       pdname = vdname;
    END IF;
    
    IF ploc IS NULL THEN
       ploc = vloc;
    END IF;

    UPDATE tbl_dept
    SET  dname = pdname, loc = ploc 
    WHERE deptno = pdeptno;
    COMMIT;
-- EXCEPTION
END;
-- [문제] tbl_dept 테이블의 레코드 수정  upupdatetbldept
CREATE OR REPLACE PROCEDURE upupdatetbldept
(
     pdeptno tbl_dept.deptno%TYPE
   , pdname tbl_dept.dname%TYPE := NULL
   , ploc tbl_dept.loc%TYPE := NULL
)
IS 
BEGIN      
    UPDATE tbl_dept
    SET  dname = NVL(pdname, dname)
        , loc = CASE 
                     WHEN ploc IS NULL THEN loc
                     ELSE ploc
                END
    WHERE deptno = pdeptno;
    COMMIT;
-- EXCEPTION
END;
--
SELECT * FROM tbl_dept;
EXEC upupdatetbldept( 50, 'X', 'Y' );  -- dname, loc
EXEC upupdatetbldept( pdeptno=>50,  pdname=>'QC3' );  -- loc
EXEC upupdatetbldept( pdeptno=>50,  ploc=>'SEOUL' );  -- 

-- [문제] 명시적 커서를 사용해서 모든 부서원 조회  : upselecttblemp
SELECT * FROM tbl_emp;
--
CREATE OR REPLACE PROCEDURE upselecttblemp 
(
   pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
   CURSOR vecursor IS (
      SELECT * 
      FROM tbl_emp
      WHERE deptno = NVL(pdeptno, 10)  -- 동적쿼리.. 
   );
   verow tbl_emp%ROWTYPE;
BEGIN
   OPEN vecursor;
   LOOP
     FETCH vecursor INTO verow;
     EXIT WHEN vecursor%NOTFOUND;
     DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP;
   CLOSE vecursor;
-- EXCEPTION
END;
--
-- [문제] 명시적 커서를 사용해서 모든 부서원 조회  : upselecttblemp
--       ( 커서에 파라미터를 이용하는 방법.. )
SELECT * FROM tbl_emp;
--
CREATE OR REPLACE PROCEDURE upselecttblemp 
(
   pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
   CURSOR vecursor( cdeptno tbl_emp.deptno%TYPE  ) IS (
      SELECT * 
      FROM tbl_emp
      WHERE deptno = NVL(cdeptno, 10) 
   );
   verow tbl_emp%ROWTYPE;
BEGIN
   OPEN vecursor(pdeptno);  -- 커서에 파라미터를 이용하는 방법..
   LOOP
     FETCH vecursor INTO verow;
     EXIT WHEN vecursor%NOTFOUND;
     DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP;
   CLOSE vecursor;
-- EXCEPTION
END;
--
-- [문제] 명시적 커서를 사용해서 모든 부서원 조회  : upselecttblemp
--       ( FORM 문을 이용하는 방법.. )
SELECT * FROM tbl_emp;
--
CREATE OR REPLACE PROCEDURE upselecttblemp 
(
   pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
BEGIN
   FOR  verow IN (SELECT * 
                  FROM tbl_emp
                  WHERE deptno = NVL(pdeptno, 10) )
   LOOP
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
-- EXCEPTION
END;
-- 
EXECUTE UPSELECTTBLEMP(30);
EXECUTE UPSELECTTBLEMP;

-- [ 파라미터 모드(mode) : IN, 1) OUT,  2) IN OUT  ]
-- [문제] insa테이블에 사원번호를 매개변수로 받아서
--       사원명, 주민번호 등등 반환하는 출력용 매개변수를 사용하는 
--       저장 프로시저를 생성 + 테스트
CREATE OR REPLACE PROCEDURE upselectinsa
(
    pnum IN insa.num%TYPE ,
    pname OUT insa.name%TYPE ,
    pssn  OUT insa.ssn%TYPE
)
IS
   vssn  insa.ssn%TYPE;
BEGIN
    SELECT name, ssn INTO pname, vssn
    FROM insa
    WHERE num = pnum;
    
    pssn := RPAD(SUBSTR(vssn, 0, 8), 14, '*');
-- EXCEPTION
END;
-- 테스트
-- EXECUTE UPSELECTINSA( 1001 );
DECLARE
  vname  insa.name%TYPE;
  vssn   insa.ssn%TYPE;
BEGIN
   UPSELECTINSA( 1001 , vname, vssn);   
   DBMS_OUTPUT.PUT_LINE( vname || ' , ' || vssn );
END;

-- [ IN/OUT 입출력용으로 사용되는 파라미터를 가지는 저장 프로시저.. ]
CREATE OR REPLACE PROCEDURE upssn
(
    pssn IN OUT VARCHAR2
)
IS
BEGIN
   pssn := SUBSTR( pssn, 0, 6 );
-- EXCEPTION
END;
--
DECLARE
  vssn VARCHAR2(14) := '911123-1700001';
BEGIN
   upssn(vssn);
   DBMS_OUTPUT.PUT_LINE( vssn ); 
--EXCEPTION
END;

-- [문제] 
DROP TABLE tbl_score PURGE;
CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);
-- 1/2/3/4/...
CREATE SEQUENCE seq_tbl_score;
-- 문제1) 학생 추가하는 저장 프로시저 생성/테스트 
EXEC up_insertscore( '홍길동', 89,44,55 );
EXEC up_insertscore( '윤재민', 49,55,95 );
EXEC up_insertscore( '김도균', 90,94,95 );
EXEC up_insertscore( '이시훈', 89,75,15 );
EXEC up_insertscore( '송세호', 67,44,75 );

EXEC up_insertscore( '서영학', 100,100,100 );

--
CREATE OR REPLACE PROCEDURE up_insertscore
(
      pname VARCHAR2
    , pkor  NUMBER := 0
    , peng  NUMBER := 0
    , pmat  NUMBER := 0
)
IS 
   vtot NUMBER(3) := 0;
   vavg NUMBER(5,2) ;
   vgrade tbl_score.grade%TYPE;
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot/3;
    -- 평균이 90이상 A, 80 이상 B, 70 C  ~ F
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;

    INSERT INTO tbl_score (num, name, kor, eng, mat, tot, avg, rank, grade )
    VALUES ( SEQ_TBL_SCORE.NEXTVAL, pname, pkor, peng, pmat, vtot,vavg, 1, vgrade );
    
    -- 등수처리하는 프로시저 또는 함수를 호출
    UP_RANKSCORE;
    
    COMMIT;
-- EXCEPTION
END;
--
SELECT *
FROM tbl_score;

-- 문제2) up_updateScore 저장프로시적
SELECT * 
FROM tbl_score;
--
EXEC up_updateScore( 6, 0, 0, 0 );

EXEC up_updateScore( 1, 100, 100, 100 );
EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1, peng =>45, pmat => 90 );

create or replace PROCEDURE up_updateScore
(
      pnum  NUMBER
    , pkor  NUMBER := NULL
    , peng  NUMBER := NULL
    , pmat  NUMBER := NULL
)
IS 
   vtot NUMBER(3) := 0;
   vavg NUMBER(5,2) ;
   vgrade tbl_score.grade%TYPE;

   vkor NUMBER(3); -- 수정 전의 원래 점수값
   veng NUMBER(3); -- 수정 전의 원래 점수값
   vmat NUMBER(3); -- 수정 전의 원래 점수값
BEGIN
    SELECT kor, eng, mat INTO vkor, veng, vmat
    FROM tbl_score
    WHERE num = pnum;

    vtot := NVL( pkor, vkor ) + NVL( peng, veng) + NVL(pmat, vmat);
    vavg := vtot/3;
    -- 평균이 90이상 A, 80 이상 B, 70 C  ~ F
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;

    UPDATE tbl_score
    SET kor = NVL( pkor, vkor ), eng=NVL( peng, veng)
    , mat = NVL(pmat, vmat), tot = vtot, avg = vavg, grade=vgrade
    WHERE num = pnum;

    -- 등수처리하는 프로시저 또는 함수를 호출
    UP_RANKSCORE;
    
    COMMIT;
-- EXCEPTION
END;

-- [문제] tbl_score 테이블의 모든 학생들의 등수를 처리하는 프로시저 생성.
CREATE OR REPLACE PROCEDURE up_rankscore
IS
BEGIN
  UPDATE tbl_score p
  SET rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE p.tot < tot );
  COMMIT;
-- EXCEPTION
END;

EXECUTE UP_RANKSCORE;

-- 
CREATE OR REPLACE PROCEDURE up_selectinsa
IS
  -- vicursor  커서자료형;
  vicursor  SYS_REFCURSOR; -- SELECT 문 적용 X 실행
BEGIN
  -- OPEN ~ FOR 문 사용.
   OPEN vicursor FOR SELECT name, city, basicpay FROM insa;
   
   UP_XXXX(vicursor);  -- LOOP~ FETCH / CLOSE
-- EXCEPTION
END;

-- 
SELECT name, ssn
  , uf_age( ssn, 1)
  , uf_gender( ssn )
FROM insa;

-- 저장 함수 --
-- [문제] 주민등록번호 -> 성별  '남자'/'여자' 반환하는 함수 
CREATE OR REPLACE FUNCTION uf_gender
( 
   pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
  vgender VARCHAR2(6) := '남자';
BEGIN
     IF MOD( SUBSTR(pssn, -7, 1), 2 ) = 0 THEN
        vgender := '여자';
     END IF; 
    RETURN (vgender);
-- EXCEPTION
END;

SELECT name, scott.uf_gender(ssn)
FROM scott.insa;

-- ssn -> 만나이/세는나이
-- uf_age
-- ssn, 1 만나이
--      0 세는나이
-- days07. 에 있음~~~~
--------------------------------------------------------------------------------  
-- [문제] insa 테이블에서 주민등록번호를 사용해서 만나이를 계산해서 출력.
--      만나이 = 올해년도(2025) - 생일년도(1977) -1  생일지나지않으면
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
--------------------------------------------------------------------------------  
CREATE OR REPLACE FUNCTION uf_age
(
  pssn VARCHAR2,
  ptype NUMBER   -- 0 세는 나이,   1 만나이
)
RETURN NUMBER
IS
    ㄱ NUMBER(4);  -- 올해년도
    ㄴ NUMBER(4);  -- 생일년도
    ㄷ NUMBER(1);   -- 생일 지남 여부   -1 0  1
    vcountingage NUMBER(3);  -- 세는 나이
    vamericanage NUMBER(3);  -- 만 나이
BEGIN
    -- 세는 나이 =  올해년도 - 생일년도 + 1
    -- 만   나이 =  올해년도 - 생일년도      생일지남여부 -1 
    --          =   세는 나이 -1        +  ( 생일지남여부 -1 )
    ㄱ :=  TO_CHAR( SYSDATE, 'YYYY' );
    ㄴ :=  CASE 
             WHEN SUBSTR(pssn, -7, 1) IN (1,2,5,6) THEN 1900
             WHEN REGEXP_LIKE(SUBSTR(pssn, -7, 1), '[3478]') THEN 2000
             ELSE 1800
           END + SUBSTR( pssn, 1, 2);
    ㄷ :=   SIGN( TO_DATE( SUBSTR( pssn, 3,4)  , 'MMDD' ) - TRUNC( SYSDATE ) );   
    
    vcountingage := ㄱ - ㄴ + 1;
    vamericanage := vcountingage-1 - CASE ㄷ
                                         WHEN 1 THEN 1
                                         ELSE 0
                                      END;
    
    IF ptype = 0 THEN
       RETURN vcountingage;
    ELSE
       RETURN vamericanage;
    END IF;
    
-- EXCEPTION
END;

SELECT ssn, uf_Age(ssn, 1),  uf_Age(ssn, 0) 
FROM insa;

-- [문제] ssn ->  "1998.01.20(화)"  uf_birth
CREATE OR REPLACE FUNCTION uf_birth
(  
   pssn VARCHAR2
)
RETURN VARCHAR2
IS 
   vcentry NUMBER(2);  -- 18, 19, 20
   vbirth VARCHAR2(20); -- "1998.01.20(화)"
BEGIN      
   vbirth := SUBSTR(pssn, 0, 6);  --  771212
   vcentry := CASE 
               WHEN SUBSTR(pssn, -7,1) IN (1,2,5,6) THEN 19
               WHEN SUBSTR(pssn, -7,1) IN (3,4,7,8) THEN 20
               ELSE 18
             END;
  vbirth :=  vcentry ||  vbirth;  -- '19771212'
  vbirth :=  TO_CHAR( TO_DATE( vbirth ), 'YYYY.MM.DD(DY)');
  RETURN (vbirth);
--EXCEPTION
END;

--
SELECT ssn, UF_BIRTH(ssn)
FROM insa;