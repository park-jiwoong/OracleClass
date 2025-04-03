DROP TABLE VOTE;
DROP TABLE LISTS;
DROP TABLE SURVEY;
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MID      VARCHAR2(20)              PRIMARY KEY
    ,MNAME   VARCHAR2(20) NOT NULL
    ,MGRADE  VARCHAR2(20) NOT NULL
);

INSERT INTO member (mid, mname, mgrade) VALUES ( '관리자', '관리자', 'admin');
INSERT INTO member (mid, mname, mgrade) VALUES ( 'M001', '이정인', 'user');
INSERT INTO member (mid, mname, mgrade) VALUES ( 'M002', '김승효', 'user');
INSERT INTO member (mid, mname, mgrade) VALUES ( 'M003', '김유미', 'user');
INSERT INTO member (mid, mname, mgrade) VALUES ( 'M004', '서주원', 'user');
INSERT INTO member (mid, mname, mgrade) VALUES ( 'M005', '이창익', 'user');


CREATE TABLE SURVEY (
     SCODE      NUMBER(3)              PRIMARY KEY
    ,SQUESTION   VARCHAR2(250) NOT NULL
    ,STARTDATE  DATE NOT NULL
    ,ENDDATE DATE NOT NULL
    ,CREATEDATETIME VARCHAR2(100) DEFAULT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
    ,MID      VARCHAR2(20) NOT NULL
    , FOREIGN KEY (MID) REFERENCES MEMBER(MID) 
    ,STATUS VARCHAR2(10) NOT NULL
);


INSERT INTO survey(SCODE, SQUESTION, STARTDATE, ENDDATE, MID, STATUS) VALUES(1, '오늘의 점심밥은 ?', SYSDATE, SYSDATE + 7,  '관리자', '진행중');
INSERT INTO survey(SCODE, SQUESTION, STARTDATE, ENDDATE, MID, STATUS) VALUES(2, '가장 좋아하는 아이돌은 ?', SYSDATE, SYSDATE + 7,  '관리자', '진행중');
INSERT INTO survey(SCODE, SQUESTION, STARTDATE, ENDDATE, MID, STATUS) VALUES(3, '오늘의 아침밥은 ?', SYSDATE, SYSDATE + 7,  '관리자', '진행중');



CREATE TABLE LISTS (
     LCODE      VARCHAR2(20)      PRIMARY KEY
    , LCONTENT   VARCHAR2(100) NOT NULL
    , SCODE      NUMBER(3)
    , FOREIGN KEY (SCODE) REFERENCES SURVEY(SCODE)
);



INSERT into LISTS( lcode , lcontent , scode ) 
            VALUES ( 1 , '한식뷔페' , 1 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 2 , 'KFC' , 1 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 3 , '에드워리드가 말아주는 김치마리국수' , 1 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 4 , '백종원이 드럼통으로 만들어주는 돼지고기' , 1 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 5 , '최현석이 만들어주는 마늘빠진 알리오올리오' , 1 );             


INSERT into LISTS( lcode , lcontent , scode ) 
            VALUES ( 6 , '오늘 너무 슬픈일이 있었는데 나와줄수 있냐고 하는 카리나' , 2 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 7 , '같이 케이크 먹자고 하는 송하영' , 2 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 8 , '일본에 있는 디지니랜드 가고 싶다는 이채영' , 2 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 9 , '귀신이 무섭다고 빨리 집으로 와달라는 윈터' , 2 );
INSERT into LISTS( lcode , lcontent , scode ) 
             VALUES ( 10 , '외모췤하는 오해원' , 2 );   


CREATE TABLE VOTE (
    VCODE      VARCHAR2(20)              PRIMARY KEY
    , MID      VARCHAR2(20) 
    ,  FOREIGN KEY (MID) REFERENCES MEMBER(MID) 
    , LCODE      VARCHAR2(20)
    , FOREIGN KEY (LCODE) REFERENCES LISTS(LCODE) 
);


INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('1', 'M001', 1);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('2', 'M002', 1);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('3', 'M003', 2);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('4', 'M004', 2);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('5', 'M005', 3);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('6', 'M001', 7);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('7', 'M002', 6);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('8', 'M003', 8);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('9', 'M004', 9);
INSERT INTO VOTE (VCODE, MID, LCODE) VALUES ('10', 'M005', 10);


select l.lcontent  AS 항목
     , count(*)  AS 답변개수 
     , rpad ( ' ' , COUNT(*) + 1 , '#' ) AS 그래프 
     , ROUND ( COUNT (*) / ( SELECT COUNT(*) FROM lists WHERE scode = 1 ) , 2 ) * 100 || '%' as 비율
from vote v join lists l on v.lcode = l.lcode
where scode = 1
group by l.lcode, l.lcontent;

SELECT l.lcode
FROM vote v JOIN lists l ON v.lcode = l.lcode
GROUP BY l.LCODE;

SELECT SQUESTION AS 질문
     , m.mid AS 작성자
     , lcontent AS 항목
     , s.CREATEDATETIME AS 작성일
     , STARTDATE AS 시작일
     , ENDDATE AS 종료일
     , STATUS  AS 상태
     ,( SELECT COUNT(*) FROM lists WHERE scode=1 ) AS 항목개수
FROM SURVEY s JOIN LISTS l ON s.scode = l.scode
              JOIN MEMBER m ON s.mid = m.mid
WHERE s.scode = 1;

select s.squestion AS 질문
    , s.mid AS 작성자
    , s.startdate AS 시작일
    , s.enddate AS 종료일
    , (select count(*) from lists where scode = s.scode) as "항목수"
    , (SELECT COUNT(*) AS 참여자수
       FROM VOTE V
       JOIN LISTS L ON V.LCODE = L.LCODE
       WHERE L.SCODE = S.SCODE)  AS "참여수"
from survey s ;

















