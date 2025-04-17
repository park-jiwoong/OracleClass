DROP SEQUENCE seq_tblcstVSBoard
DROP TABLE tbl_cstVSBoard;
CREATE SEQUENCE seq_tblcstVSBoard
NOCACHE;

CREATE TABLE tbl_cstVSBoard (
  seq NUMBER NOT NULL PRIMARY KEY,
  writer VARCHAR2(20) NOT NULL ,
  pwd VARCHAR2(20)  NOT NULL ,
  email VARCHAR2(100) ,
  title VARCHAR2(200)  NOT NULL ,
  writedate DATE  DEFAULT SYSDATE,
  readed NUMBER  DEFAULT 0,
  tag NUMBER(1) NOT NULL ,
  content CLOB
);
--Table TBL_CSTVSBOARD이(가) 생성되었습니다.
-- 더미 데이터 생성

select *
from user

BEGIN
    FOR i IN 1..150 LOOP
        INSERT INTO TBL_CSTVSBOARD (seq, writer, pwd, email, title, tag, content)
        VALUES (SEQ_TBLCSTVSBOARD.NEXTVAL, 
                '홍길동' || MOD(i, 10), 
                '1234',
                '홍길동' || MOD(i, 10) || '@sist.co.kr', 
                '더미...' || i,  -- 여기에서 마침표 대신 콤마 사용
                0,
                '더미...' || i   -- 여기에서도 마침표 대신 콤마 사용
        );
    END LOOP;
    END;
commit;

-----
         BEGIN
            UPDATE tbl_cstVSBoard
            SET writer = '권태정'
            WHERE MOD(seq, 15) = 4;
            COMMIT;
         END;
         --
          BEGIN
             UPDATE tbl_cstVSBoard
             SET title = '게시판 구현'
             WHERE MOD(seq, 15) IN ( 3, 5, 8 );
             COMMIT;
          END;


select * from tbl_cstVSBoard;

----------------------------------------------
select seq, title, writer, email, writedate, readed
from tbl_cstVSBoard
ORDER BY seq DESC;

COMMIT;

