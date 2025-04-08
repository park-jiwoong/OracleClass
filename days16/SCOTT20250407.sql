-- SOCTT --
ALTER SYSTEM REGISTER;
FROM insa;
-- 트리거 테스트 --

CREATE TABLE tbl_examl
(
    id_NUMBER PRIMARY KEY
    , name VARCHAR2(20)
);

CREATE TABLE tbl_exam2
(
    memo VARCHAR2(100)
    ,ilja DATE DEFAULT SYSDATE
);

-- tbl_exml 테이블에 INSERT, UPDATE, DELETE 이벤트를 발생시키면
-- 자동으로 tbl_exam2 테이블에 tbl_exam1 테이블에 어떤 작업이 일어났는 지를
-- 로그로 기록하는 트리거를 작성하는 예제

CREATE OR REPLACE TRIGGER ut_log
BEFORE | AFTER
INSERT OR DELETE ON UPDATE ON tbl_exam1 -- <- 여기서 삭제를 하려면 DELETE ON tbl_exam1 넣어줘야 한다
FOR EACH ROW -- <- 요거도 추가해줘야함
-- DECLARE
BEGIN
    IF INSERTING THEN
        INSERT INTO tbl_exam2 (memo) VALUES (:NEW.name || '추가 로그 기록...')
    ELSIF DELETING THEN
        INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '추가 로그 기록...')
    ELSIF
        INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '수정 로그 기록...')
    END IF;

-- 저장 프로시저는 COMMIT, ROLLBACK 해야 된다
-- 트리거는 자동으로 COMMIT, ROLLBAKC 이 된다. X
-- EXCEPTION
END;

SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2;
--
IN
INSERT INTO tbl_exam1 VALUES (1, 'hong');
INSERT INTO tbl_exam1 VALUES (1, 'kim');
INSERT INTO tbl_exam1 VALUES (1, 'park');
ROLLBACK; --INSERT를 롤백 해서
--(SELECT * FROM tbl_exam1;) -> SELECT * FROM tbl_exam2; 도 같이 롤백됨
COMMIT; -- <- 마지막에 커밋 해준다

-- 2. 삭제할 떄도 Trigger에 의해서 로그 작성
DELETE FROM tbl_exam1
WHERE id = 2;

--3.    1, hong -> admin 수정(UPDATE)
UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 1;

--tbl_exam1 대상 테이블로 DML문이 근무시간(9~17시) 외 또는 주말에는 처리 X
CREATE OR REPLACE TRIGGER ut_log_before
BEFORE
INSERT OR DELETE ON UPDATE ON tbl_exam1 -- <- 여기서 삭제를 하려면 DELETE ON tbl_exam1 넣어줘야 한다
BEFORE | AFTER
INSERT OR DELETE ON UPDATE ON tbl_exam1 -- <- 여기서 삭제를 하려면 DELETE ON tbl_exam1 넣어줘야 한다
--FOR EACH ROW -- <- 요거도 추가해줘야함
-- DECLARE
BEGIN
    IF TO_CHAR(SYSDATE, 'DY')N('토', '일')
    OR TO_CHAR(SYSDATE, 'hh24') < 11
    OR TO_CHAR(SYSDATE, 'hh24') < 18

    RAISE_APPLICATION_ERROR(-20001, '근무시간이 아니기에 DML 작업 처리할 수 없다.');
   
    END IF;

-- 저장 프로시저는 COMMIT, ROLLBACK 해야 된다
-- 트리거는 자동으로 COMMIT, ROLLBAKC 이 된다. X
-- EXCEPTION
END;

INSERT INTO tbl_exam1 VALUES (4, 'lee');
SELECT * FROM tbl_Exam1;

DROP TABLE tbl_exam1;
DROP TABLE tbl_exam2;

-- 실전 트리거 예제
--상품테이블
--PK          재고수량
--1   냉장고     10 -- <- 자동으로 +5 trigger에 의해서 트리거 재고수량 수정
--2   TV        20
--3

--판매테이블
--    냉장고     7       INSERT
--
--입고테이블
--    냉장고     5      INSERT

-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명        VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격     NUMBER
  ,재고수량       NUMBER DEFAULT 0
);
-- Table 상품이(가) 생성되었습니다.
-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);
-- Table 입고이(가) 생성되었습니다.

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);
--
-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;
--
SELECT * FROM 상품;

-- 문제1) 입고 테이블에 상품이 입고가 되면 자동으로 상품 테이블의 재고수량이
-- update 되는 트리거 생성 + 확인
-- 입고 테이블에 데이터 입력  
--  ut_insIpgo
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
INSERT ON 입고
FOR EACH ROW
-- DECLARE
BEGIN
    UPDATE 상품 
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
END;


--
SELECT * FROM 상품;

INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT;
--
SELECT * FROM 입고;
SELECT * FROM 상품;

-- [문제2] 입고 테이블에서 입고가 수정되는 경우    상품테이블의 재고수량 수정. 
UPDATE 입고 
SET 입고수량 = 30 
WHERE 입고번호 = 5; -- ←입고 번호가 수정이 일어남
COMMIT;
--
CREATE OR REPLACE TRIGGER ut_udpIpgo
AFTER
UPDATE ON 입고
FOR EACH ROW
-- DECLARE
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
END;
--
-- 문제3) 입고 테이블에서 입고가 취소되어서 입고 삭제.    상품테이블의 재고수량 수정. 
--  5 입고  25 -> 30    취소
DELETE FROM 입고 
WHERE 입고번호 = 5;
COMMIT;
--
CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER
DELETE ON 입고
FOR EACH ROW
-- DECLARE
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드 = :OLD.상품코드;
END;

SELECT * FROM 입고;

SELECT * FROM 상품;
SELECT * FROM 판매;

-- 문제4) 판매테이블에 판매가 되면 (INSERT) 
--       상품테이블의 재고수량이 (-) 수정  
--       ut_insPan
--
CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
INSERT ON 판매
FOR EACH ROW
DECLARE
  vqty 상품.재고수량%TYPE;
BEGIN
   SELECT 재고수량  INTO vqty
   FROM 상품
   WHERE 상품코드 = :NEW.상품코드;
   
   IF vqty < :NEW.판매수량 THEN
      RAISE_APPLICATION_ERROR(-20007, '재고수량 부족으로 판매 오류');
   ELSE
      UPDATE  상품
      SET 재고수량 = 재고수량 - :NEW.판매수량
      WHERE 상품코드 = :NEW.상품코드;
   END IF;
   
-- EXCEPTION
END;
--
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2023-11-10', 5, 1000000);
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT;
select * from 판매;
select * from 상품;


-- 문제5) 판매번호 1  20     판매수량 5 -> 30 
-- 
UPDATE 판매 
SET 판매수량 = 30 -- 30 로 바뀌었을 때는 바뀌지 않음
WHERE 판매번호 = 1;
--
CREATE OR REPLACE TRIGGER   ut_updPan
BEFORE
UPDATE ON 판매 
FOR EACH ROW -- 행 레벨 트리거
DECLARE
  vqty 상품.재고수량%TYPE;
BEGIN
  SELECT 재고수량 INTO vqty   -- 15
  FROM 상품
  WHERE 상품코드 = :NEW.상품코드;
 
  -- :OLD.판매수량  5
  -- :NEW.판매수량  10
  IF  ( vqty + :OLD.판매수량 ) < :NEW.판매수량 THEN
    RAISE_APPLICATION_ERROR(-20007, '재고수량 부족으로 판매 오류');
  ELSE 
     UPDATE 상품
     SET 재고수량 = 재고수량 +:OLD.판매수량  - :NEW.판매수량
     WHERE 상품코드 = :NEW.상품코드;
  END IF;  
--EXCEPTION
END;


-- 문제6)판매번호 1   (AAAAA  10)   판매 취소 (DELETE)
--      상품테이블에 재고수량 수정
--      ut_delPan
CREATE OR REPLACE TRIGGER   ut_delPan
AFTER
DELETE ON 판매
FOR EACH ROW -- 행 레벨 트리거
BEGIN    
     UPDATE 상품
     SET 재고수량 = 재고수량 + :OLD.판매수량
     WHERE 상품코드 = :OLD.상품코드;  
  -- COMMIT/ROLLBACK X
-- EXCEPTION
END;
-- 
DELETE FROM 판매 
WHERE 판매번호=1;
-- 
SELECT * FROM 판매;
SELECT * FROM 상품;

