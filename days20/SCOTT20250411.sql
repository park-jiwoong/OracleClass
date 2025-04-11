-- SCOTT --
delete from tbl_dept;
commit;
--
SELECT *
FROM tbl_dept; // dept 테이블 csv 데이터 넣는 작업
---------------------------
-- [작업 스케줄러] 
-- 데이터베이스 내에 생성한 프로시저, 함수들에 대해 데이터베이스 내의 스케쥴러에 지정한 시간에 
-- 자동으로 작업이 진행될 수 있도록 하는 기능이다.

-- [2가지 방법]
--1) DBMS_JOB 패키지
--    ㄱ. PL/SQL 블럭 생성 (프로시저, 함수) 생성
--    ㄴ. 스케줄 설정
--    ㄷ. 잡 생성/삭제/중지 기능 체크

--2) DBMS_SCHEDUER 패키지 (오라클 10g 이후) 권장

CREATE TABLE tbl_job
(
    seq NUMBER
    , insert_date DATE
);

--Table TBL_JOB이(가) 생성되었습니다.

CREATE OR REPLACE PROCEDURE up_job
--()
IS
  vseq NUMBER; -- <- NUMBER 놓침
BEGIN
   -- 시퀀스 역할..
   SELECT  MAX( NVL(seq,0) ) + 1 INTO vseq
   FROM tbl_job;
   --
   INSERT INTO tbl_job VALUES ( vseq, SYSDATE );
   
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE( SQLERRM );
END;
----------- Procedure UP_JOB이(가) 컴파일되었습니다.

-- JOB 등록 (DBMS_JOB.SUBMIT() 저장프로시저) 익명프로시저를 사용
-- ? 잡코드 번호를 알아와서 잡 중지/삭제...
-- EXECUTE, 아웃풋 용으로 하려고
DECLARE
    vjob_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
        job => vjob_no -- 출력용(out) 파라미터
        , what => 'UP_JOB;'-- 실행할 PL/SQL 블럭 (저장 프로시저)
        ,next_date => SYSDATE -- (job이 등록되자마자 실행하겠다) 작업을 최초 실행 시점
     -- , interval => 'SYSDATE + 1'  하루에 한 번  문자열 설정
       -- , interval => 'SYSDATE + 1/24'
       -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'일요일') + 15/24'
       --    매주 일요일 오후3시 마다.
       -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
       --    매월 마지막 일의   6시 30분 마다..
       , interval => 'SYSDATE + 1/24/60' -- 매 분 마다       
    );
    COMMIT;
          DBMS_OUTPUT.PUT_LINE( '잡 등록된 번호 : '|| vjob_no );
--EXCEPTION
END;

--PL/SQL 프로시저가 성공적으로 완료되었습니다.
-- 잡 등록된 번호 : 42 
SELECT *
FROM user_jobs;
--FROM user_constraints;
--FROM user_tables;
-- 41 X /42
BEGIN
    DBMS_JOB.REMOVE(4);
    COMMIT;
END;
--
SELECT seq, TO_CHAR(insert_date, 'DL TS ')
FROM tbl_job;

BEGIN
    DBMS_JOB.BROKEN(5, true);
COMMIT;
END;

-- job 삭제: DBMS_JOB.REMOVE(41);
-- job 일시중지 -> 다시 시작
BEGIN
    DBMS_JOB.BROKEN(5, false);
COMMIT;
END;
-- 잡의 실행 주기랑 상관없이 살행할 때
BEGIN
    DBMS_JOB.RUN(5);
END;
-- 잡 속성 변경: DBMS_JOB.CHANGE() 저장 프로시저를 사용하면 된다
-- 42 잡도 삭제(제거)
BEGIN
    DBMS_JOB.REMOVE(5);
    COMMIT;
END;
--
SELECT *
FROM user_jobs;


----------------------------------------------------------
--[강사님 작성부분]
-- SCOTT -- 
-- [작업 스케줄러 ]  
-- 데이터베이스 내에 생성한 PL/SQL( 프로시저, 함수)들에 대해 데이터베이스 
-- 내의 스케쥴러에 지정한 시간에 자동으로 작업이 진행될 수 있도록 하는 기능이다.

--*** 1) DBMS_JOB 패키지 
--        ㄱ. PLSQL 블럭 생성 ( 프로시저, 함수 ) 생성
--        ㄴ. 스케줄 설정
--        ㄷ. 잡 생성/삭제/중지/  기능 체크

--2) DMBS_SCHEDUER 패키지 ( 오라클 10g 이후 ) 권장.

-- 실습) 테이블 생성
CREATE TABLE tbl_job
(
   seq NUMBER
   , insert_date DATE
);
-- Table TBL_JOB이(가) 생성되었습니다.

CREATE OR REPLACE PROCEDURE up_job
--()
IS
  vseq NUMBER;
BEGIN
   -- 시퀀스 역할..
   SELECT  MAX( NVL(seq,0) ) + 1 INTO vseq
   FROM tbl_job;
   --
   INSERT INTO tbl_job VALUES ( vseq, SYSDATE );
   
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE( SQLERRM );
END;
-- Procedure UP_JOB이(가) 컴파일되었습니다.

-- JOB 등록 ( DBMS_JOB.SUMIT() 저장프로시저 )  익명프로시저를 사용.
-- ? 잡코드 번호를 알아와서 잡 중지/삭제 ... 
DECLARE
  vjob_no NUMBER;
BEGIN
  DBMS_JOB.SUBMIT(
     job => vjob_no   -- 출력용(OUT) 파라미터
     , what =>  'UP_JOB;'  -- 실행할 PL/SQL 블럭( 저장 프로시저 )
     , next_date => SYSDATE    -- 최조 실행 시점
      -- , interval => 'SYSDATE + 1'  하루에 한 번  문자열 설정
       -- , interval => 'SYSDATE + 1/24'
       -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'일요일') + 15/24'
       --    매주 일요일 오후3시 마다.
       -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
       --    매월 마지막 일의   6시 30분 마다..
     , interval => 'SYSDATE + 1/24/60' -- 매 분 마다       
  );  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE( '잡 등록된 번호 : ' || vjob_no );     
--EXCEPTION
END;
-- 잡 등록된 번호 : 42
SELECT * 
FROM user_jobs;
FROM user_users;
FROM user_constraints;
FROM user_tables;
-- 41 X  /42
BEGIN
  DBMS_JOB.REMOVE(41);
  COMMIT;
END; 
--
SELECT seq, TO_CHAR( insert_date, 'DL TS' )
FrOM tbl_job;

-- 잡 삭제 : DBMS_JOB.REMOVE(41);
-- 잡 일시중지
BEGIN
   DBMS_JOB.BROKEN(42, true);
   CoMMIT;
END;

-- 잡 일시중지 -> 재시작
BEGIN
   DBMS_JOB.BROKEN(42, false);
   CoMMIT;
END;
-- 잡의 실행 주기랑 상관없이 실행
BEGIN
  DBMS_JOB.RUN(42);
END;
-- 잡 속성 변경 : DBMS_JOB.CHAGE() 저장 프로시저를 사용하면 된다. 
-- 42 잡도 삭제(제거 )
BEGIN
  DBMS_JOB.REMOVE(42);
  COMMIT;
END;
--
SELECT * 
FrOM user_jobs;

-- JDBC  : 인덱스, 암호화 스프링








