-- [SURVEY] 20250402

-- [테이블 생성]

/* 사용자 */
CREATE TABLE member (
	nickname VARCHAR2(50) NOT NULL /* 닉네임 */
);

ALTER TABLE member
	ADD
		CONSTRAINT PK_member
		PRIMARY KEY (
			nickname
		);

/* 설문 */
CREATE TABLE survey (
	scode NUMBER(5) NOT NULL, /* 설문코드 */
	nickname VARCHAR2(50) NOT NULL, /* 작성자 */
	squestion VARCHAR2(250) NOT NULL, /* 질문 */
	startdate DATE NOT NULL, /* 시작일 */
	enddate DATE NOT NULL /* 종료일 */
);

ALTER TABLE survey
	ADD
		CONSTRAINT PK_survey
		PRIMARY KEY (
			scode
		);


ALTER TABLE survey  
ADD CONSTRAINT chk_nickname CHECK (nickname = '관리자');

/* 참여 */
CREATE TABLE participation (
	pcode NUMBER(10) NOT NULL, /* 참여코드 */
	pselection NUMBER(2) NOT NULL, /* 선택한 항목 */
	nickname VARCHAR2(50) NOT NULL, /* 닉네임 */
	scode NUMBER(5) NOT NULL /* 설문코드 */
);

ALTER TABLE participation
	ADD
		CONSTRAINT PK_participation
		PRIMARY KEY (
			pcode
		);

/* 항목 */
CREATE TABLE content (
	cnum NUMBER(2) NOT NULL, /* 항목번호 */
	scode NUMBER(5) NOT NULL, /* 설문코드 */
	cbody VARCHAR2(250) NOT NULL /* 항목내용 */
);

ALTER TABLE SURVEY
	ADD sdate DATE NOT NULL;
    
ALTER TABLE content
	ADD
		CONSTRAINT PK_content
		PRIMARY KEY (
			cnum,
			scode
		);

ALTER TABLE survey
	ADD
		CONSTRAINT FK_member_TO_survey
		FOREIGN KEY (
			nickname
		)
		REFERENCES member (
			nickname
		);

ALTER TABLE participation
	ADD
		CONSTRAINT FK_member_TO_participation
		FOREIGN KEY (
			nickname
		)
		REFERENCES member (
			nickname
		);

ALTER TABLE participation
	ADD
		CONSTRAINT FK_survey_TO_participation
		FOREIGN KEY (
			scode
		)
		REFERENCES survey (
			scode
		) ON DELETE CASCADE;

ALTER TABLE content
	ADD 
		CONSTRAINT FK_survey_TO_content
		FOREIGN KEY (
			scode
		)
		REFERENCES survey (
			scode
		) ON DELETE CASCADE;
        
COMMIT;
------------------------------------------------------------

-- 사용자 데이터 삽입
INSERT INTO member VALUES ('홍길동');
INSERT INTO member VALUES ('김민준');
INSERT INTO member VALUES ('이서윤');
INSERT INTO member VALUES ('박지훈');
INSERT INTO member VALUES ('최예린');
INSERT INTO member VALUES ('정도현');
INSERT INTO member VALUES ('강하늘');
INSERT INTO member VALUES ('윤서연');
INSERT INTO member VALUES ('한지우');
INSERT INTO member VALUES ('배도현');
INSERT INTO member VALUES ('조윤아');
INSERT INTO member VALUES ('신우진');
INSERT INTO member VALUES ('장예담');
INSERT INTO member VALUES ('오수빈');
INSERT INTO member VALUES ('권시현');
INSERT INTO member VALUES ('서도윤');
INSERT INTO member VALUES ('임하영');
INSERT INTO member VALUES ('홍석우');
INSERT INTO member VALUES ('김다혜');
INSERT INTO member VALUES ('이준서');
INSERT INTO member VALUES ('관리자');
--------------------------------------------

-- 설문 데이터 삽입
INSERT INTO survey
VALUES (1, '관리자', '하루 평균 수면시간이 어떻게 되시나요?', '25/03/01','25/04/01',SYSDATE);
INSERT INTO content VALUES (1, 1, '1~2시간');
INSERT INTO content VALUES (2, 1, '3~5시간');
INSERT INTO content VALUES (3, 1, '6~8시간');
INSERT INTO content VALUES (4, 1, '8시간 이상');

INSERT INTO survey
VALUES (2, '관리자', '일 평균 스마트폰 사용시간은 어떻게 되시나요?', '25/04/01','25/05/01',SYSDATE);
INSERT INTO content VALUES (1, 2, '30분 이하');
INSERT INTO content VALUES (2, 2, '1~2시간');
INSERT INTO content VALUES (3, 2, '3~5시간');
INSERT INTO content VALUES (4, 2, '5시간 이상');

INSERT INTO survey
VALUES (3, '관리자', '일주일 평균 운동량이 어떻게 되시나요?(시간기준)', '25/05/01','25/06/01',SYSDATE);
INSERT INTO content VALUES (1, 3, '30분 이하');
INSERT INTO content VALUES (2, 3, '1~2시간');
INSERT INTO content VALUES (3, 3, '3~5시간');
INSERT INTO content VALUES (4, 3, '운동 안 함');

INSERT INTO survey
VALUES (4, '관리자', '가장 좋아하는 과일이 무엇인가요?', '25/04/01','25/05/01',SYSDATE);
INSERT INTO content VALUES (1, 4, '딸기');
INSERT INTO content VALUES (2, 4, '사과');
INSERT INTO content VALUES (3, 4, '바나나');
------------------------------------------------------------------------------------------

-- 참여 데이터 삽입
CREATE SEQUENCE participation_seq START WITH 1;

-- 마지막 값 = 1인 경우 (11개)
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '김민준', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '이서윤', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '박지훈', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '최예린', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '정도현', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '강하늘', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '윤서연', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '한지우', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '배도현', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '조윤아', 1);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '홍길동', 1);

-- 마지막 값 = 2인 경우 (10개)
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '김민준', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '이서윤', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '박지훈', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '최예린', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '정도현', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '강하늘', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '윤서연', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '한지우', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '배도현', 2);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '조윤아', 2);

-- 마지막 값 = 3인 경우 (10개)
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '신우진', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '장예담', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '오수빈', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '권시현', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '서도윤', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '임하영', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '홍석우', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '김다혜', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '이준서', 3);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 4, '관리자', 3);

-- 마지막 값 = 4인 경우 (10개)
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '김민준', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '이서윤', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '박지훈', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '최예린', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '정도현', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '강하늘', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 2, '윤서연', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '한지우', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 1, '배도현', 4);
INSERT INTO participation VALUES (participation_seq.NEXTVAL, 3, '조윤아', 4);

COMMIT;
-----------------------------------------------------------------------------------

-- 데이터 확인/점검용 쿼리들
SELECT * FROM survey ORDER BY scode;
SELECT scode, cnum, cbody FROM content ORDER BY scode, cnum;
SELECT * FROM participation;

SELECT *
FROM survey s JOIN content c ON s.scode = c.scode;

SELECT *
FROM survey s JOIN content c ON s.scode = c.scode
              JOIN participation p ON c.cnum = p.pselection;

SELECT squestion, cbody, count(p.nickname)
FROM survey s JOIN content c ON s.scode = c.scode
              JOIN participation p ON s.scode = p.scode AND c.cnum = p.pselection
GROUP BY s.scode, squestion, cnum, cbody, pselection
ORDER BY s.scode, cnum;

SELECT squestion, count(p.nickname)
FROM survey s JOIN content c ON s.scode = c.scode
              JOIN participation p ON s.scode = p.scode AND c.cnum = p.pselection
GROUP BY s.scode, squestion
ORDER BY s.scode;
-------------------------------------------------------------------------------------

-- 워드패드 내용 쿼리

-- 1. 메인 페이지
-- [1] 최신 설문조사 질문과 문항 출력하는 쿼리
WITH t AS (
    SELECT *
    FROM (
    SELECT s.scode
    FROM survey s JOIN content c ON s.scode = c.scode
    ORDER BY sdate DESC
) 
WHERE ROWNUM = 1)
SELECT squestion "최신 설문조사 질문" , cbody "문항"
FROM survey s JOIN content c ON s.scode = c.scode
WHERE c.scode = (SELECT * FROM t);
--

-- 2. 설문 목록
-- [1] 설문 목록을 아래와 같이 출력하는 쿼리 작성
SELECT s.scode 번호, squestion 질문, s.nickname 작성자,
       startdate 시작일, enddate 종료일, MAX(cnum) 항목수,
       count(p.nickname) 참여자수,
       CASE 
        WHEN SYSDATE < startdate THEN '시작전'
        WHEN SYSDATE > enddate THEN '종료'
        ELSE '진행중'
       END 상태
FROM survey s JOIN content c ON s.scode = c.scode
              LEFT JOIN participation p ON s.scode = p.scode AND c.cnum = p.pselection
GROUP BY s.scode, squestion, s.nickname, startdate, enddate
ORDER BY s.scode DESC;
--

-- 3. 설문작성
-- 질문, 설문 시작일, 종료일, 항목수, 항목내용 입력
SELECT squestion 질문, cbody 항목, startdate 시작일, enddate 종료일
FROM survey s JOIN content c ON s.scode = c.scode
WHERE s.scode = 1
ORDER BY s.scode, cnum;

-- 4. 설문 상세 보기
-- [1] 설문 목록에서 하나의 설문을 선택해서 선택한 설문 내용 출력하는 쿼리 작성
--
-- [2] 총 참여자 수 조회하는 쿼리 작성
SELECT count(*) 총참여자수
FROM participation
WHERE scode=1;
--
-- [3] 투표하기 관련 쿼리 작성
--
-- [4] 현재 설문 결과를 그래프로 나타내는 쿼리 작성
SELECT squestion 질문, cnum 항목번호, cbody 항목,
       COUNT(p.nickname) AS 참여자수, 
       ROUND(COUNT(p.nickname) * 100 / SUM(COUNT(p.nickname)) OVER (), 1) || '%' AS 비율,
       LPAD('*', ROUND(COUNT(p.nickname) * 100 / SUM(COUNT(p.nickname)) OVER ()), '*') AS 그래프
FROM survey s
JOIN content c ON s.scode = c.scode
JOIN participation p ON s.scode = p.scode AND c.cnum = p.pselection
WHERE s.scode = 1
GROUP BY squestion, cnum, cbody
ORDER BY squestion, cnum, cbody;
--

-- 5. 관리자가 설문 수정하는 쿼리 작성
UPDATE survey
SET squestion = '원하는 질문 내용으로 수정'
WHERE scode=1;

UPDATE content
SET cbody = '원하는 항목 내용으로 수정'
WHERE scode=1 AND cnum=1;
--

-- 6. 관리자가 설문 삭제하는 쿼리 작성
DELETE FROM survey WHERE scode=1;
--








