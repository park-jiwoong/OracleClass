select * from all_tables;

drop table vote;
drop table SurveyAnswer;
drop table survey;
drop table member;
drop table grade;
--------------------------------------------------------------------------------

create table grade (
    gid int primary key, 
    grade varchar2(20)
);
--------------------------------------------------------------------------------

create table member (
        mid int PRIMARY KEY,
        gid int,
        name varchar2(30),
        constraint fk_member_grade FOREIGN key(gid) REFERENCES grade(gid)
);
--------------------------------------------------------------------------------
        
create table survey (
        sid int PRIMARY KEY,
        mid int,
        startDate date,
        endDate date,
        rdate date,
        voteCnt int,
        content varchar2(255),
        constraint fk_survey_writer FOREIGN key(mid) REFERENCES member(mid)
);
--------------------------------------------------------------------------------

create table SurveyAnswer (
        aid int PRIMARY KEY,
        sid int,
        aContent varchar2(255),
        CONSTRAINT fk_answer_question FOREIGN key(sid) REFERENCES survey(sid)
);
--------------------------------------------------------------------------------
     
create table vote (
        vid int primary key,
        mid int,
        sid int,
        aid int,
        CONSTRAINT fk_vote_member FOREIGN KEY (mid) REFERENCES Member(mid),
        CONSTRAINT fk_vote_survey FOREIGN KEY (sid) REFERENCES Survey(sid),
        CONSTRAINT fk_vote_answer FOREIGN KEY (aid) REFERENCES SurveyAnswer(aid)
);

--------------------------------------------------------------------------------

INSERT INTO grade (gid, grade) VALUES (1, '일반회원');
INSERT INTO grade (gid, grade) VALUES (2, '우수회원');
INSERT INTO grade (gid, grade) VALUES (3, '관리자');
select * from grade;

--------------------------------------------------------------------------------

INSERT INTO member (mid, gid, name) VALUES (1, 1, '김철수');
INSERT INTO member (mid, gid, name) VALUES (2, 2, '박영희');
INSERT INTO member (mid, gid, name) VALUES (3, 3, '최민수');
INSERT INTO member (mid, gid, name) VALUES (4, 1, '이지은');
INSERT INTO member (mid, gid, name) VALUES (5, 2, '송중기');
select * from member;

--------------------------------------------------------------------------------

INSERT INTO survey (sid, mid, startDate, endDate, rdate, voteCnt, content) VALUES (1, 1, '2025-04-06', '2025-05-26', '2025-01-18', 4, '어떤 음식을 가장 좋아하시나요?');
INSERT INTO survey (sid, mid, startDate, endDate, rdate, voteCnt, content) VALUES (2, 2, '2025-04-05', '2025-04-16', '2025-04-04', 4, '가장 좋아하는 영화 장르는 무엇인가요?');
INSERT INTO survey (sid, mid, startDate, endDate, rdate, voteCnt, content) VALUES (3, 3, '2025-02-04', '2025-05-19', '2025-02-04', 4, '여행 가고 싶은 나라는 어디인가요?');
select * from survey;

--------------------------------------------------------------------------------

INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (1, 1, '한식');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (2, 1, '양식');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (3, 1, '중식');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (4, 1, '일식');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (5, 2, '로맨스');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (6, 2, '액션');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (7, 2, '판타지');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (8, 2, '뮤지컬');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (9, 3, '프랑스');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (10, 3, '이탈리아');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (11, 3, '미국');
INSERT INTO SurveyAnswer (aid, sid, aContent) VALUES (12, 3, '한국');
select * from SurveyAnswer;

--------------------------------------------------------------------------------

INSERT INTO vote (vid, mid, sid, aid) VALUES (1, 1, 1, 1);
INSERT INTO vote (vid, mid, sid, aid) VALUES (2, 3, 1, 2);
INSERT INTO vote (vid, mid, sid, aid) VALUES (3, 2, 1, 3);
INSERT INTO vote (vid, mid, sid, aid) VALUES (4, 2, 2, 6);
INSERT INTO vote (vid, mid, sid, aid) VALUES (5, 3, 2, 5);
INSERT INTO vote (vid, mid, sid, aid) VALUES (6, 4, 2, 7);
INSERT INTO vote (vid, mid, sid, aid) VALUES (7, 4, 3, 9);
INSERT INTO vote (vid, mid, sid, aid) VALUES (8, 2, 3, 9);
INSERT INTO vote (vid, mid, sid, aid) VALUES (9, 1, 3, 11);
INSERT INTO vote (vid, mid, sid, aid) VALUES (10, 5, 3, 10);
select * from vote;

--------------------------------------------------------------------------------

select
sid 번호
, content 질문
, (select mid from member where mid = s.mid) 작성자
, startDate 시작일
, endDate 종료일
, voteCnt 항목수
, (select count(*) from vote v where v.sid = s.sid) 참여자수
, case when startDate < sysdate and endDate > sysdate then '진행중'
       when startDate > sysdate then '준비중'
       when endDate < sysdate then '종료' end 상태
from survey s;

--------------------------------------------------------------------------------

select * from grade;
select * from member;
select * from survey;
select * from SurveyAnswer;
select * from vote;












