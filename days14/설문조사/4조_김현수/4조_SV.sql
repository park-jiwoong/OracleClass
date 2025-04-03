-- 회원등급 테이블
CREATE TABLE 회원등급 (
    등급번호코드 NUMBER PRIMARY KEY,
    등급 VARCHAR2(20) NOT NULL
);

-- 회원 테이블
CREATE TABLE 회원 (
    회원번호 NUMBER(4) PRIMARY KEY,
    회원ID VARCHAR2(20) NOT NULL,
    회원이름 VARCHAR2(20) NOT NULL,
    등급번호코드 NUMBER,
    CONSTRAINT FK_회원_회원등급 FOREIGN KEY (등급번호코드)
        REFERENCES 회원등급(등급번호코드)
);

-- 설문목록 테이블
CREATE TABLE 설문목록 (
    설문번호 NUMBER(2) PRIMARY KEY,
    제목 VARCHAR2(200) NOT NULL,
    질문 VARCHAR2(500),
    시작일 DATE,
    종료일 DATE
);

ALTER TABLE 설문목록 ADD 작성자_회원번호 NUMBER(4);
ALTER TABLE 설문목록 ADD CONSTRAINT FK_설문목록_회원 FOREIGN KEY (작성자_회원번호) REFERENCES 회원(회원번호);

-- 항목 테이블
CREATE TABLE 항목 (
    항목번호 NUMBER(2) PRIMARY KEY,
    항목내용 VARCHAR2(500) NOT NULL,
    설문번호 NUMBER(2),
    CONSTRAINT FK_항목_설문목록 FOREIGN KEY (설문번호)
        REFERENCES 설문목록(설문번호)
);

-- 설문참여내용 테이블
CREATE TABLE 설문참여내용 (
    설문참여번호 NUMBER(3) PRIMARY KEY,
    회원번호 NUMBER(4),
    설문번호 NUMBER(2),
    항목번호 NUMBER(2),
    CONSTRAINT FK_설참_회원 FOREIGN KEY (회원번호)
        REFERENCES 회원(회원번호),
    CONSTRAINT FK_설참_설문 FOREIGN KEY (설문번호)
        REFERENCES 설문목록(설문번호),
    CONSTRAINT FK_설참_항목 FOREIGN KEY (항목번호)
        REFERENCES 항목(항목번호)
);


----------------삽입-----------------

INSERT INTO 회원등급 (등급번호코드, 등급) VALUES (1, '일반');
INSERT INTO 회원등급 (등급번호코드, 등급) VALUES (3, '관리자');

INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1001, 'user01', '김민수', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1002, 'user02', '이영희', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1003, 'user03', '박지훈', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1004, 'user04', '최수진', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1005, 'user05', '강동원', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1006, 'user06', '한지민', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1007, 'user07', '오세훈', 3); -- 관리자
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1008, 'user08', '정유미', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1009, 'user09', '김태리', 1); -- 일반
INSERT INTO 회원 (회원번호, 회원ID, 회원이름, 등급번호코드) VALUES (1010, 'user10', '장기용', 1); -- 일반

INSERT INTO 설문목록 (설문번호, 제목, 질문, 시작일, 종료일,작성자_회원번호) 
VALUES (1, '2025년 고객 만족도 조사', '서비스에 얼마나 만족하십니까?', '2025-04-01', '2025-04-15', 1007);
INSERT INTO 설문목록 (설문번호, 제목, 질문, 시작일, 종료일,작성자_회원번호) 
VALUES (2, '신제품 선호도 조사', '어떤 신제품을 선호하십니까?', '2025-04-02', '2025-04-20', 1007);
INSERT INTO 설문목록 (설문번호, 제목, 질문, 시작일, 종료일,작성자_회원번호) 
VALUES (3, '브랜드 선호도 조사', '어떤 브랜드를 선호하십니까?', '2025-03-29', '2025-04-19', 1004);
INSERT INTO 설문목록 (설문번호, 제목, 질문, 시작일, 종료일,작성자_회원번호) 
VALUES (4, '브랜드 만족도 조사', '브랜드에 얼마나 만족하십니까?', '2025-04-02', '2025-04-20', 1006);


-- 설문 1 항목
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (1, '매우 만족', 1);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (2, '보통', 1);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (3, '불만족', 1);

-- 설문 2 항목
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (4, '제품 A', 2);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (5, '제품 B', 2);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (6, '제품 C', 2);

-- 설문 3 항목
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (7, 'A 브랜드', 3);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (8, 'B 브랜드', 3);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (9, 'C 브랜드', 3);

-- 설문 4 항목
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (10, '매우 만족', 4);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (11, '보통', 4);
INSERT INTO 항목 (항목번호, 항목내용, 설문번호) VALUES (12, '불만족', 4);

INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (1, 1001, 1, 1);
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (2, 1002, 1, 2); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (3, 1003, 1, 3); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (4, 1004, 2, 4); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (5, 1005, 2, 5); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (6, 1006, 1, 1); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (7, 1007, 2, 6); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (8, 1008, 1, 2); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (9, 1009, 2, 4); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (10, 1010, 1, 3); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (11, 1005, 3, 7); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (12, 1006, 3, 8); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (13, 1007, 3, 8); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (14, 1008, 4, 10); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (15, 1009, 4, 12); 
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호) VALUES (16, 1010, 4, 11); 
-----------------------------------------
--설문 목록 출력(시작일 내림차순)    
SELECT 
    s.설문번호 AS 번호,
    s.제목,
    m.회원이름 AS 작성자,
    s.시작일,
    s.종료일,
    (SELECT COUNT(*) FROM 항목 a WHERE a.설문번호 = s.설문번호) AS 항목수,
    (SELECT COUNT(DISTINCT p.회원번호) FROM 설문참여내용 p WHERE p.설문번호 = s.설문번호) AS 참여자수,
    CASE 
        WHEN s.종료일 < SYSDATE THEN '마감'
        ELSE '진행중'
    END AS 상태
FROM 
    설문목록 s
JOIN 
    회원 m ON s.작성자_회원번호 = m.회원번호
ORDER BY 시작일 DESC;

--상세보기
SELECT 
    s.설문번호,
    s.제목,
    s.질문,
    s.시작일,
    s.종료일,
    a.항목번호,
    a.항목내용
FROM 
    설문목록 s
JOIN 
    항목 a ON s.설문번호 = a.설문번호
WHERE 
    s.설문번호 = 1;  -- 예: 설문번호 1번 선택
    
--참여자 수
SELECT 
    COUNT(DISTINCT 회원번호) AS 참여자수
FROM 
    설문참여내용
WHERE 
    설문번호 = 1;  -- 예: 설문번호 1번 선택

--투표하기    
INSERT INTO 설문참여내용 (설문참여번호, 회원번호, 설문번호, 항목번호)
VALUES (11, 1001, 1, 1);  -- 예: 김민수가 설문 1번의 '매우 만족'에 투표

--결과 및 그래프 출력
SELECT 
    a.항목번호,
    a.항목내용,
    COUNT(p.항목번호) AS 투표수,
    ROUND((COUNT(p.항목번호) * 100.0 / SUM(COUNT(p.항목번호)) OVER ()), 2) AS 비율,
    RPAD('#', ROUND((COUNT(p.항목번호) * 100.0 / SUM(COUNT(p.항목번호)) OVER ()) / 100 * 30), '#') AS 그래프
FROM 
    항목 a
LEFT JOIN 
    설문참여내용 p ON a.항목번호 = p.항목번호 AND p.설문번호 = a.설문번호
WHERE 
    a.설문번호 = 4
GROUP BY 
    a.항목번호, a.항목내용;

-- 설문 정보 수정
UPDATE 설문목록
SET 제목 = '2025년 고객 만족도 조사(수정)',
    질문 = '서비스 만족도를 평가해주세요.',
    시작일 = '2025-04-01',
    종료일 = '2025-04-20'
WHERE 설문번호 = 1;

-- 항목 내용 수정
UPDATE 항목
SET 항목내용 = '매우 만족(수정)'
WHERE 항목번호 = 1 AND 설문번호 = 1;

-- 설문 참여 내용 삭제
DELETE FROM 설문참여내용 
WHERE 설문번호 = 1;

-- 항목 삭제
DELETE FROM 항목 
WHERE 설문번호 = 1;

-- 설문 삭제
DELETE FROM 설문목록 
WHERE 설문번호 = 5;


