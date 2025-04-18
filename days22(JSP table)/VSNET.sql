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


select * from tbl_cstVSBoard
where seq = 1;
----------------------------------------------
select seq, title, writer, email, writedate, readed
from tbl_cstVSBoard
ORDER BY seq DESC;

COMMIT;
----------------------------------------------
----- 현재페이지 : 1 / 한페이지당 출력할 게시글 수 : 10
SELECT * 
FROM tbl_cstVSBoard
ORDER BY seq DESC;
-- TOP - N 방식 --
SELECT *
FROM (
    SELECT ROWNUM no, t.*
    FROM (
        SELECT * -- 칼럼만 바꿔주자
        FROM tbl_cstVSBoard
        ORDER BY seq DESC;
        )t
)b
WHERE no BETWEEN ? AND ?; -- ?페이지
WHERE no BETWEEN 1 AND 10; -- 1페이지
WHERE no BETWEEN 11 AND 20; -- 2페이지
WHERE no BETWEEN 21 AND 30; -- 3페이지

select count(*) from tbl_cstVSBoard;





 SELECT * 
 FROM (    
   SELECT ROWNUM no, t.*     
   FROM (        
          SELECT *         
          FROM tbl_cstVSBoard         
          ORDER BY seq DESC        
  )t 
)b 
WHERE no BETWEEN 51 AND 60;




