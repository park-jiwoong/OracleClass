-- SCOTT --
---- [트랜잭션 (Transaction)]
--예) 계좌 이체    (A -> B 이체)
--트랜잭션 처리 시 잠금(LOOK) -- <-- 잠금을 걸어줌
--1) A 계좌에서 이체할 금액만큼 인출하는 UPDATE 문 실행 -- 성공
--2) B 계좌에 인출한 금액만큼을 UPDATE 문 실행        -- 실패
--위의 1) + 2) DML 문을 실행
---- 모두 DML문이 성공(완료) COMMIT 작업
---- 모두 DML문이 실패      ROLLBACK 작업

--저장 프로시져: BEGIN ~ commit / rollback END;
--테이블 DML -> 트리거 (트리거는 커밋 롤백이 필요하지 않음 ) why? 테이블의 조건을 따라가기 때문에
select '<'||userenv('sessionid')
  ||'>SQL>' sq from dual;
-- 사용자 A
COMMIT;
DROP TABLE tbl_dept PURGE;
--
CREATE TABLE tbl_dept
AS
    SELECT * FROM dept;
-- 1) 사용자 A
INSERT INTO tbl_dept
VALUES (50,'QC','SEOUL')
--
SELECT *
FROM tbl_dept;
--
SAVEPOINT a; -- <- 키워드 예약어
-- 여기까지 DML - 커밋 / 롤백 X -> 잠금
-- 2) UPDATE
UPDATE tbl_dept
SET loc = 'SEOUL'
WHERE deptno = 40;
-- 여기까지 DML - 커밋/롤백 x -> 잠금상태

ROLLBACK;
ROLLBACK TO SAVEPOINT a;
ROLLBACK TO a;
COMMIT;

-- PL/SQL - 익평프로지서,  저장 프로시저, 저장 함수, 

-- [ 패키지 ] -------------------------------------------------------------------
-- Package EMPLOYEE_PKG이(가) 컴파일되었습니다.
-- 패키지의 명세서 부분
CREATE OR REPLACE PACKAGE employee_pkg 
AS
    -- 서브프로그램 ( 저장 프로시저, 저장 함수 만 )
    procedure print_ename(p_empno number); 
    procedure print_sal(p_empno number); 
    -- 만나이, 나이..
    FUNCTION uf_age
    (
        pssn IN VARCHAR2
        , ptype IN NUMBER
    )
    RETURN NUMBER;
END employee_pkg; 


-- 패키지 몸체 부분
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure print_ename(p_empno number) is 
         l_ename emp.ename%type; 
       begin 
         select ename 
           into l_ename 
           from emp 
           where empno = p_empno; 
       dbms_output.put_line(l_ename); 
      exception 
        when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end print_ename; 
   
   procedure print_sal(p_empno number) is 
      l_sal emp.sal%type; 
    begin 
      select sal 
       into l_sal 
        from emp 
        where empno = p_empno; 
     dbms_output.put_line(l_sal); 
    exception 
      when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
   end print_sal;  
   
   FUNCTION uf_age
(
   pssn IN VARCHAR2 
  ,ptype IN NUMBER --  1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS
   ㄱ NUMBER(4);  -- 올해년도
   ㄴ NUMBER(4);  -- 생일년도
   ㄷ NUMBER(1);  -- 생일 지남 여부    -1 , 0 , 1
   vcounting_age NUMBER(3); -- 세는 나이 
   vamerican_age NUMBER(3); -- 만 나이 
BEGIN
   -- 만나이 = 올해년도 - 생일년도    생일지남여부X  -1 결정.
   --       =  세는나이 -1  
   -- 세는나이 = 올해년도 - 생일년도 +1 ;
   ㄱ := TO_CHAR(SYSDATE, 'YYYY');
   ㄴ := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   ㄷ :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (생일X)

   vcounting_age := ㄱ - ㄴ +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ㄷ, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ㄷ
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 
-- Package Body EMPLOYEE_PKG이(가) 컴파일되었습니다.


SELECT name, ssn,   EMPLOYEE_PKG.UF_AGE( ssn, 1) age
FROM insa;

