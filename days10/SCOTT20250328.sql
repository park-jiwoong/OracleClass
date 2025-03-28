-- SCOTT -- 
-- [ 테이블 생성, 수정, 삭제 ]
--         DDL 문 - CREATE TABLE, ALTER TABLE, DROP TABLE 
--  테이블 ? 
-- 실습) 테이블 생성
-- 아이디/이름/나이/연락처/생일/비고
--PK 아이디   문자(고정/[가변] 길이  VARCHAR2(10))    크기(SIZE)   UK PK NN CK
--이름    문자() VARCHAR2(20)
--나이    숫자() NUMBER(3)                                   CK 0~130
--전화번호  문자() VARCHAR2(20)  X
--생일    날짜()  DATE
--비고    문자()  VARCHAR2(255) X
DROP TABLE tbl_sample PURGE;
CREATE TABLE tbl_sample
( 
       id  VARCHAR2(10)
       , name VARCHAR2(20)
       , age NUMBER(3)
       , birth DATE
); 
-- Table TBL_SAMPLE이(가) 생성되었습니다.
SELECT *
FROM tabs
WHERE table_name LIKE 'TBL\_S%' ESCAPE '\';
WHERE REGEXP_LIKE( table_name, '^tbl_s', 'i' );
--
DESC tbl_sample;
-- 테이블 생성 -> 수정. :  전화번호, 비고 컬럼 추가.
-- DDL 문 : ALTER TABLE 문 사용 
SELECT *
FROM tbl_sample;
-- 
ALTER TABLE tbl_sample
ADD (
         tel   VARCHAR2(20)   -- DEFAULT '000-0000-0000'
       , bigo  VARCHAR2(255)
    );
-- Table TBL_SAMPLE이(가) 변경되었습니다.
SELECT *
FROM tbl_sample;
-- [컬럼의 크기를 수정]
-- 비고 컬럼의 Size(크기) 255 byte -> 100 으로 수정.
ALTER TABLE tbl_sample
MODIFY ( bigo VARCHAR2(100) );
-- Table TBL_SAMPLE이(가) 변경되었습니다.
DESC tbl_sample;
-- BIGO     VARCHAR2(100) 

-- [컬럼명을 수정]
-- 1) bigo 컬럼명을   memo 컬럼명으로 수정.
SELECT name, bigo AS "memo"
FROM tbl_sample;
-- 2)
ALTER TABLE tbl_sample
RENAME COLUMN bigo TO memo;

-- [컬럼 삭제 - memo]
ALTER TABLE tbl_sample
        DROP COLUMN memo; 
-- Table TBL_SAMPLE이(가) 변경되었습니다.

-- [tal_sample 테이블이름 변경 : tbl_example ]
RENAME tbl_sample TO tbl_example;

-- [ 게시판 테이블 생성 + CRUD 등등 쿼리 작성.]
DROP TABle TBL_BOARD PURGE;
CREATE TABLE tbl_board
(
     seq       NUMBER(38) NOT NULL PRIMARY KEY -- UK + NN
   , writer    VARCHAR2(20) NOT NULL
   , password  VARCHAR2(15) NOT NULL           -- CK
   , title     VARCHAR2(100) NOT NULL
   , content   CLOB
   , regdate   DATE DEFAULT SYSDATE
);

-- 조회수 컬럼 추가   readed NUMBER(38) 기본값 0
ALTER TABLE tbl_board
ADD   readed NUMBER(38) DEFAULT 0  ;
--
DESC tbl_board;
-- 게시판 새글 작성 INSERT문 --
INSERT INTO tbl_board (seq, writer, password, title, content)
VALUES (1, '홍길동', '1234', '환절기 건강 조심', null );
INSERT INTO tbl_board (seq, writer, password, title, content)
VALUES (2, '권태정', '1234', '밥 먹고 싶다.', '배고프다.' );
INSERT INTO tbl_board (seq, writer, password, title, content)
VALUES (3, '김승효', '1234', '세 번째 게시글', '세 번째 게시글' );
COMMIT;
SELECT * 
FROM tbl_board
ORDER BY seq DESC;
-- 시퀀스 생성 +  순번( seq ) 1/2/3/4      PA0001
CREATE SEQUENCE seq_tbl_board
START WITH 4;
-- 11:03 수업시작~
-- 시퀀스 생성 확인
SELECT *
FROM user_sequences
WHERE sequence_name LIKE 'SEQ_T%';
FROM user_tables;
-- 
INSERT INTO tbl_board (seq, writer, password, title, content)
VALUES (  seq_tbl_board.NEXTVAL , '서영학', '1234', '시퀀스 사용', '네 번째 게시글' );
COMMIT;
SELECT * 
FROM tbl_board
ORDER BY seq DESC;
--
SELECT seq_tbl_board.CURRVAL
FROM dual;

--[ title 컬럼명 - subuject 컬럼명 수정]
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;
--[ writer 컬럼 크기 20 -  40 크기 확장]
ALTER TABLE tbl_board
MODIFY (writer VARCHAR2(40));
-- [ 테이블 생성하는 방법 ]
--1. CREATE TABLE문 사용해서 테이블 생성
--2. 서브쿼리를 사용한 테이블 생성
--   ㄴ 기존 이미 존재하는 테이블을 이용해서 새로운 테이블 생성
--【형식】
--	CREATE TABLE 테이블명 [컬럼명 (,컬럼명),...]
--	AS subquery;

-- 예) emp 테이블에서 사원이 30번인 부서원들만 가져와서 새로운 tbl_emp30 테이블 생성.
CREATE TABLE tbl_emp30 -- (eno, name, ibsadate, job, pay)
AS 
SELECT empno, ename, hiredate, job,  sal + NVL(comm,0) pay
FROM emp
WHERE deptno = 30;
-- Table TBL_EMP30이(가) 생성되었습니다.
DESC tbl_emp30;
--
SELECT *
FROM tbl_emp30;
-- [ 제약조건 복사 여부 확인  X ]
-- 1) emp 테이블 제약조건 확인
-- 2) TBL_EMP30 테이블 제약 조건 확인
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name = UPPER('tbl_emp30');
WHERE table_name = UPPER('emp');
--
ALTER TABLE tbl_emp30
ADD CONSTRAINT pk_tbl_emp30_empno PRIMARY KEY(empno);
-- tbl_emp30 테이블 삭제
DROP TABLE tbl_emp30 PURGE;

-- 만약에 서브쿼리를 사용해서 테이블을 생성할 때   +  데이터(레코드)는 X
DROP TABLE tbl_emp PURGE;
--
CREATE TABLE tbl_emp
AS
  SELECT * 
  FROM emp
  WHERE 1 = 0;  -- 조건절은 항상 거짓이 되도록 ...
--
  SELECT * 
  FROM tbl_emp;
  
--  TBL_ 테이블 검색
--tbl_char
--tbl_number
--tbl_pivot
--tbl_tel
--등등
-- PL/SQL   

-- [문제]  12:00 수업 시작~ 
-- 1) empno, dname, ename, pay, deptno, grade, hiredate , mgr_name
--       컬럼들을 가진 새로운 tbl_emp 테이블 생성...
CREATE TABLE tbl_emp
AS 
(
    SELECT e.empno, e.ename,  dname, e.sal+NVL(e.comm,0) pay,   d.deptno, grade,  e.hiredate
          , m.ename  mgr_ename
    FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno
               JOIN salgrade s ON  e.sal BETWEEN s.losal AND s.hisal
               LEFT JOIN emp m ON e.mgr = m.empno
    --ORDER BY deptno ASC           
);
-- 2) empno  PK 제약조건 추가
ALTER TABLE tbl_emp
ADD  PRIMARY KEY (empno);
--ADD CONSTRAINT pk_tbl_emp_empno  PRIMARY KEY (empno); -- SYS_C007850
-- 3) 제약 조건 확인.
SELECT *
FROM user_constraints
WHERE table_name = UPPER('TBL_EMP');
-- 4) 테이블 삭제
DROP TABLE tbl_emp PURGE;

-- [ DML문 -  INSERT ]     COMMIT, ROLLBACK
SELECT * FROM emp;
DESC emp;
-- ORA-00913: too many values
-- ORA-01847: day of month must be between 1 and last day of month
INSERT INTO emp (empno, hiredate) VALUES (9998, TO_DATE( '01/01/88', 'MM/DD/YY' ));
INSERT INTO emp (empno, hiredate) VALUES (9997, TO_DATE( '01/01/88', 'MM/DD/RR' ));
--
INSERT INTO emp (empno) VALUES (9999);
COMMIT;
-- 
UPDATE emp
SET   ename = 'admin', hiredate = SYSDATE
WHERE empno = 9999;
-- [ RR / YY 차이점 ]
SELECT empno, hiredate
       , TO_CHAR( hiredate, 'DS TS' ) 
FROM emp
WHERE empno >= 9000;
-- 
DELETE FROM emp
WHERE empno >= 9000;
COMMIT;
-- emp -> 구조만 복사해서 tbl_emp 테이블 생성
CREATE TABLE tbl_emp
AS 
    SELECT *
    FROM emp
    WHERE 1=0;
--
SELECT *
FROM tbl_emp;
-- [INSERT]    emp 테이블의 30번 부서원들 -> tbl_emp 테이블에 INSERT
SELECT *
FROM emp
WHERE deptno = 30;
-- (기억)
INSERT INTO 테이블명  [( 컬럼명... )] VALUES (컬럼값...);
--
INSERT INTO tbl_emp (
                        SELECT *
                        FROM emp
                        WHERE deptno = 30
);
-- 부분적인 컬럼만 INSERT
INSERT INTO tbl_emp  (empno, ename )  (
                        SELECT empno, ename
                        FROM emp
                        WHERE deptno = 20
);

COMMIT;

-- 다중 INSERT 문
1) unconditional insert all 
【형식】
	INSERT ALL | FIRST
	  [INTO 테이블1 VALUES (컬럼1,컬럼2,...)]
	  [INTO 테이블2 VALUES (컬럼1,컬럼2,...)]
	  .......
	Subquery;
-- 
CREATE TABLE tbl_emp10 AS ( SELECT * FROM emp WHERE 1=0 );
CREATE TABLE tbl_emp20 AS ( SELECT * FROM emp WHERE 1=0 );
CREATE TABLE tbl_emp30 AS ( SELECT * FROM emp WHERE 1=0 );
CREATE TABLE tbl_emp40 AS ( SELECT * FROM emp WHERE 1=0 );
--
SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;
SELECT * FROM tbl_emp40;
--
INSERT INTO tbl_emp10 ( SELECT * FROM emp ); -- 12 명
INSERT INTO tbl_emp20 ( SELECT * FROM emp ); -- 12 명
INSERT INTO tbl_emp30 ( SELECT * FROM emp ); -- 12 명
INSERT INTO tbl_emp40 ( SELECT * FROM emp ); -- 12 명
ROLLBACK ;
--
INSERT  ALL
    INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp40 (empno, ename, job, mgr) VALUES (empno, ename, job, mgr)
SELECT * 
FROM emp;
ROLLBACK;
 
2) conditional insert all : 조건이 있는 다중 INSERT ALL 문
--
SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;
SELECT * FROM tbl_emp40;
--
INSERT INTO tbl_emp10 ( SELECT * FROM emp WHERE deptno =10); -- 12 명
INSERT INTO tbl_emp20 ( SELECT * FROM emp WHERE deptno =20 ); -- 12 명
INSERT INTO tbl_emp30 ( SELECT * FROM emp WHERE deptno =30 ); -- 12 명
INSERT INTO tbl_emp40 ( SELECT * FROM emp WHERE deptno =40 ); -- 12 명
ROLLBACK ;
--\
【형식】
	INSERT ALL
        WHEN 조건절1 THEN
            INTO [테이블1] VALUES (컬럼1,컬럼2,...)
        WHEN 조건절2 THEN
            INTO [테이블2] VALUES (컬럼1,컬럼2,...)
       ........
        ELSE
            INTO [테이블3] VALUES (컬럼1,컬럼2,...)
	Subquery;
--
INSERT  ALL
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno = 20 THEN
        INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno = 30 THEN
        INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE -- 40
        INTO tbl_emp40 (empno, ename, job, mgr) VALUES (empno, ename, job, mgr)
SELECT * 
FROM emp;
--
ROLLBACK;

3) conditional first insert 
--
SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;
SELECT * FROM tbl_emp40;
ROLLBACK;
-- 16개 행 이(가) 삽입되었습니다.
INSERT  FIRST
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN sal >= 1500 THEN
        INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno = 30 THEN
        INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE -- 40
        INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT * 
FROM emp;

4) pivoting insert 
-- 
CREATE TABLE tbl_sales(
    employee_id        number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2)
);

INSERT INTO tbl_sales VALUES(1101,4,100,150,80,60,120);
INSERT INTO tbl_sales VALUES(1102,5,300,300,230,120,150);
COMMIT;
--
SELECT *
FROM tbl_sales;
-- 다중 INSERT문 4번째 경우~ 
CREATE TABLE  tbl_sales_data(
     employee_id        number(6),
     week_id            number(2),
     sales              number(8,2)
 );
SELECT * 
FROM tbl_sales_data;
--
INSERT ALL
    INTO tbl_sales_data VALUES(employee_id, week_id, sales_mon)
    INTO tbl_sales_data VALUES(employee_id, week_id, sales_tue)
    INTO tbl_sales_data VALUES(employee_id, week_id, sales_wed)
    INTO tbl_sales_data VALUES(employee_id, week_id, sales_thu)
    INTO tbl_sales_data VALUES(employee_id, week_id, sales_fri)
SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed,
        sales_thu, sales_fri
FROM tbl_sales;
-- 
DROP TABLE tbl_emp10 PURGE;
DROP TABLE tbl_emp20 PURGE;
DROP TABLE tbl_emp30 PURGE;
DROP TABLE tbl_emp40 PURGE;

DROP TABLE tbl_sales PURGE;
DROP TABLE tbl_sales_data PURGE;
-- DELETE 문    : DML문, 레코드 삭제   I,U,D + 커밋/롤백
--                WHERE 조건절 X , 모든 레코드 삭제.

-- DROP TABLE 문: DDL문( C/A/D )  테이블 삭제

-- TRUNCATE 문  :  모든 레코드 삭제.   커밋/롤백 X
-- 예) TRUNCATE TABLE 테이블명;

-- [문제] tbl_score 테이블 생성
--       insa 기존 있는 테이블의   num, name 컬럼을 복사해서 
--        num <= 1005
-- ( 조건:  서브쿼리를 사용해서 테이블 생성.  )
DROP TABLE tbl_score PURGE;
--
CREATE TABLE tbl_score
AS
   SELECT num, name
   FROM insa
   WHERE num <= 1005;
-- 제약조건 X
SELECT* 
FROM tbl_score;
-- [문제] tbl_score의 제약조건을 확인하는 쿼리 작성
SELECT *
FROM user_constraints
WHERE REGEXP_LIKE(table_name, '^tbl_s', 'i') ;
-- [문제] num 컬럼에 PK 제약조건을 설정하는 쿼리 작성
ALTER TABLE tbl_score
ADD CONSTRAINT pk_tbl_score_num PRIMARY KEY(num);
--
DESC tbl_score;
-- [문제] tbl_score 테이블에 kor, eng, mat, tot, avg, grade, rank 컬럼 추가.
--                                                  CHAR(1 CHAR) N(3)
ALTER TABLE tbl_score
ADD (
       kor  NUMBER(3) DEFAULT 0
     , eng  NUMBER(3) DEFAULT 0
     , mat  NUMBER(3) DEFAULT 0
     , tot  NUMBER(3) DEFAULT 0
     , avg  NUMBER(5,2) DEFAULT 0
     , grade CHAR(1 CHAR)
     , rank NUMBER(3) 
);
-- 
DESC tbl_score;
-- [문제] 1001~1005 ( num ) 모든 학생들의 국,영,수 점수만을 0~100 사이의
--  임의의 정수를 채워넣는 UPDATE 쿼리를 작성..
SELECT   ROUND(DBMS_RANDOM.VALUE *100) 
       , TRUNC(DBMS_RANDOM.VALUE *101) 
       , FLOOR(DBMS_RANDOM.VALUE *101)
       , FLOOR(DBMS_RANDOM.VALUE(0, 101))
FROM dual;
--
UPDATE  tbl_score
SET kor = FLOOR(DBMS_RANDOM.VALUE *101)
, eng = FLOOR(DBMS_RANDOM.VALUE *101)
, mat = FLOOR(DBMS_RANDOM.VALUE *101);
-- WHERE 
--
SELECT *
FROM tbl_score;
--
COMMIT;
-- [문제] 1005 번 학생의 국,영 점수가 1001 학생의 국-1, 영-1 점수로 UPDATE
SELECT kor-1 FROM tbl_score WHERE num = 1001;
SELECT eng-1 FROM tbl_score WHERE num = 1001;
--
UPDATE tbl_score
SET kor = (SELECT kor-1 FROM tbl_score WHERE num = 1001)
   , eng = (SELECT eng-1 FROM tbl_score WHERE num = 1001)
WHERE num = 1005;
-- 
UPDATE tbl_score
SET (kor, eng) = (SELECT kor-1, eng-1 FROM tbl_score WHERE num = 1001) 
WHERE num = 1005;
COMMIT;

--
SELECT * 
FROM tbl_score;
-- [문제] 영어 1문제 정답이 없어서 모두 5점씩 추가.. UPDATE 문 작성...
UPDATE tbl_score
SET eng = eng + 5;
--
UPDATE tbl_score
SET eng = 100
WHERE eng > 100;
-- 
UPDATE tbl_score
SET eng = CASE   
             WHEN eng + 5 > 100 THEN  100
             ELSE eng + 5
          END;
COMMIT;
 --
SELECT * 
FROM tbl_score;
-- [문제]  k,g,m  최종적 확인 -> 총점 / 평균  UPDATE
UPDATE tbl_score
SET    tot = kor + eng + mat
     , avg = (kor + eng + mat)/3;
COMMIT;
-- [문제] 등수( rank 컬럼  ) 처리   UPDATE
-- [1]
SELECT num, tot
    , (  SELECT COUNT(*)+1 FROM tbl_score WHERE tot > s.tot    ) r    
FROM tbl_score s;
-- [2]
SELECT r
FROM (
    SELECT num, tot
        , RANK() OVER( ORDER BY tot DESC ) r
    FROM tbl_Score
)
WHERE num = 1005;
--ORDER BY num asc;
-- [1-1]
UPDATE  tbl_score s
SET rank =  (  SELECT COUNT(*)+1 FROM tbl_score WHERE tot > s.tot    )  ;
-- [1-2]
UPDATE  tbl_score s
SET rank =  (  
        SELECT r
        FROM (
            SELECT num, tot
                , RANK() OVER( ORDER BY tot DESC ) r
            FROM tbl_Score
        )
        WHERE num = s.num
    )  ;
--
SELECT * 
FROM tbl_score;
COMMIT;
ROLLBACK;
-- [문제] 등급 수정
--    avg 90 이상 '수', 80 이상 '우'  ~ '가'
UPDATE tbl_score
SET  grade  = CASE
--                 WHEN avg BETWEEN 90 AND 100 THEN '수'
--                 WHEN avg BETWEEN 80 AND 89 THEN '우'
                   WHEN avg >= 90 THEN '수'
                   WHEN avg >= 80 THEN '우'
                   WHEN avg >= 70 THEN '미'
                   WHEN avg >= 60 THEN '양'
                   ELSE '가'
              END;
-- WHERE ;
-- [2]
UPDATE tbl_score
SET  grade  =  DECODE(  TRUNC( avg/10 ), 10, '수', 9, '수', 8, '우', 7,'미'
     ,6,'양','가');
-- WHERE ;

-- DECODE() 비교 = 만 사용
SELECT num, avg , TRUNC( avg/10 )
     , DECODE(  TRUNC( avg/10 ), 10, '수', 9, '수', 8, '우', 7,'미'
     ,6,'양','가')
FROM tbl_score;

-- [3] 다중 INSERT 문  -> 등급 수정.
INSERT FIRST
  WHEN avg >= 90 THEN
   INTO tbl_score(num, grade) VALUES (num, '수') 
  WHEN avg >= 80 AND  
   INTO  tbl_score(grade) VALUES ('우')
  WHEN avg >= 70 THEN  
   INTO   tbl_score(grade) VALUES ('미')
  WHEN avg >= 60 THEN 
   INTO  tbl_score(grade) VALUES ('양')
  ELSE
   INTO  tbl_score(grade) VALUES ('가')
SELECT avg
FROM tbl_score;

-- [문제] tbl_score 테이블에서 남학생들만 국어점수 10 감소. ( UPDATE )
--       (문제점) tbl_score 테이블에는 성별을 구분할 수 있는 컬럼 X
--               insa 테이블의 ssn 가지고 성별 파악해서 UPDATE  완성...
SELECT *
FROM tbl_score;
--
SELECT num
FROM insa
WHERE MOD(SUBSTR(ssn, -7,1), 2)=1;
--
UPDATE tbl_score s
SET kor  = CASE 
                WHEN kor-10 < 0 THEN 0
                ELSE kor-10
           END
WHERE s.num = (
        SELECT num
        FROM insa
        WHERE MOD(SUBSTR(ssn, -7,1), 2)=1 AND s.num = num
);

WHERE num  = ANY (    -- SOME, ANY, ALL, EXISTS
            SELECT num
            FROM insa
            WHERE MOD(SUBSTR(ssn, -7,1), 2)=1 AND num <= 1005
);            
WHERE num  IN ( 
            SELECT num
            FROM insa
            WHERE MOD(SUBSTR(ssn, -7,1), 2)=1 AND num <= 1005
);           
-- WHERE num  IN ( 1001, 1002, 1004, 1005 );
--  홍길동
UPDATE tbl_score
SET kor = CASE 
            WHEN kor-10<0 THEN 0 
            ELSE kor-10
          END
WHERE num IN (
        SELECT i.num 
        FROM insa i JOIN tbl_score t ON i.num = t.num 
        WHERE MOD(SUBSTR(ssn, -7, 1),2) = 1
    );
--
ROLLBACK;


COMMIT;
-- [문제] result  컬럼 추가 ( '합격', '불합격', '과락')
--   합격 : 평균 60점 이상, 40 미만 X
--  불합격 : 평균 60점 미만
--   과락 : 40 미만 
ALTER TABLE tbl_score
ADD result VARCHAR2(9);
-- 
SELECT *
FROM tbl_score;
--
UPDATE tbl_score
SET result = CASE
                 WHEN avg >= 60 AND kor>=40 AND eng>=40 AND mat>=40 THEN  '합격'                 
                 WHEN avg < 60 THEN  '불합격'                 
                 ELSE '과락'
             END;
-- WHERE
COMMIT;






