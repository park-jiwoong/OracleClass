-- SCOTT --
--CREATE  VIEW 뷰이름
--CREATE OR REPLACE VIEW 뷰이름
--CREATE OR REPLACE FORCE VIEW 뷰이름
--CREATE OR REPLACE FORCE NOFORCE VIEW 뷰이름
-- 실제 기존 테이블에서 쿼리 실행 (서브쿼리 작성)

-- JOIN
-- b_id, title, price, g_id, g_name, p_date, p_su

SELECT b_id, title, price, g.g_id, g_name, p_date, p_su
FROM book b
    JOIN danga d ON (b.b_id = d.b_id)
    JOIN panmai p ON (b.b_id = p.b_id)
    JOIN gogaek g ON (g.g_id = p.g_id);
-- 쿼리 실행 과정 이해. (Optimizer)
CREATE OR REPLACE VIEW uvpan
    --
AS
    SELECT b_id, title, price, g.g_id, g_name, p_date, p_su
    FROM book b
    JOIN danga d ON (b.b_id = d.b_id)
    JOIN panmai p ON (b.b_id = p.b_id)
    JOIN gogaek g ON (g.g_id = p.g_id);
    
-- 권한 확인 --
SELECT *
FROM user_sys_privs;

-- View 사용 --
SELECT *
FROM uvpan
WHERE b_id = 'a-1'
ORDER BY p_date ASC;
--FROM 테이블명 또는 view명
-- 모든 뷰를 조회 --
SELECT *
FROM user_views;
FROM user_users;
FROM user_constraints;
FROM user_tables;

-- ABVIEW
-- BVIEW
DROP VIEW BVIEW;
DROP VIEW ABVIEW;

-- [문제] 년도, 월, 고객코드, 고객명, 판매금액합
-- 년도, 월 오름차순 정렬
-- uvgogaek 뷰(View)를 생성하고 확인
CREATE OR REPLACE VIEW uvgogaek
AS
SELECT
    TO_CHAR(p_date, 'YYYY') AS p_year,     -- AS 추가 (선택 사항, 가독성 향상)
    TO_CHAR(p_date, 'MM') AS p_month,      -- AS 추가
    g.g_id,
    g.g_name,
    SUM(d.price * p.p_su) AS 판매금액합    -- AS 추가, 테이블 별칭 d 사용
FROM
    panmai p
JOIN
    gogaek g ON (g.g_id = p.g_id)
JOIN
    danga d ON (d.b_id = p.b_id)       -- 테이블명 오타 수정 (dnaga -> danga)
GROUP BY
    TO_CHAR(p_date, 'YYYY'),            -- GROUP BY 절에서 별칭 제거
    TO_CHAR(p_date, 'MM'),              -- GROUP BY 절에서 별칭 제거
    g.g_id,
    g.g_name
ORDER BY
    p_year,                             -- ORDER BY 에서는 별칭 사용 가능
    p_month;

-- VIEW 구조 확인 --
DESC uvgogaek;

-- 뷰

CREATE TABLE testa (
   aid     NUMBER                  PRIMARY KEY
    ,name   VARCHAR2(20) NOT NULL
    ,tel    VARCHAR2(20) NOT NULL
    ,memo   VARCHAR2(100)
);

CREATE TABLE testb (
    bid NUMBER                      PRIMARY KEY
    ,aid NUMBER CONSTRAINT fk_testb_aid 
                REFERENCES testa(aid)
                ON DELETE CASCADE
    ,score NUMBER(3)
);
------ [INSERT] 문 ------
INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;
--
SELECT * FROM testa;
SELECT * FROM testB; 

-- SIMPLE VIEW (단순 뷰) --
CREATE OR REPLACE VIEW aView
AS
    SELECT aid, name, memo
FROM testa;
--View AVIEW이(가) 생성되었습니다.
-- 단순 뷰를 사용해서 INSERT
INSERT INTO aview (aid, name, memo) VALUES (6, 'g', 'null');
--ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")
--1 행 이(가) 삽입되었습니다.

-- 단순뷰 삭제 --
DELETE FROM aView
WHERE aid = 5;
ROLLBACK;
SELECT * FROM aVIew;

-- 단순뷰 수정 --
--SQL 오류: ORA-00904: "TEL": invalid identifier
UPDATE aView
--SET tel = '55'
SET memo = 'up'
WHERE aid = 5;
--1 행 이(가) 업데이트되었습니다.
DROP VIEW aView;

-- 복합뷰를 생성 - DML 작업
CREATE OR REPLACE VIEW abView
AS
    SELECT
        a.aid, name, tel    -- testa 기존테이블의 컬럼
            ,bid, score     -- testa 기존테이블의 컬럼
    FROM testa a JOIN testb b ON (a.aid = b.aid)
    ;
-- SELECT O
SELECT *
FROM abView;
-- INSERT
-- 오류: ORA-01779 : cannot modify a column which maps to a non
-- key-preserved table
-- 뷰를 사용해서      testa           testa
-- 동시에 두 개의 테이블에 INSERT, UPDATE 작업을 할 수 없다
-- 단) 한개의 테이블에 INSERT, UPDATE 작업은 가능하다
INSERT INTO abView (aid, name, tel, bid, score)
    VALUES (10, 'x', 55, 20, 70);
    
--INSERT INTO abView (aid, name, tel, bid, score)
--    VALUES (10, 'x', 55);

UPDATE abView
SET score = 99
WHERE bid = 1;
COMMIT;

DELETE FROM abView
WHERE aid = 1;
--1 행 이(가) 삭제되었습니다.
COMMIT;
select * from abView;

-- [WITH CHECK OPTION 설명]
--  ㄴ 뷰에 의해 access될 수 있는 행(row)만이 삽입, 수정 가능
-- testb 테이블에서 score 가 90 점 이상인 결과만을 가지는 뷰를 생성
select * from testb;

CREATE OR REPLACE VIEW bView
AS
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90;
--  View BVIEW이(가) 생성되었습니다.
SELECT * FROM bView;
SELECT * FROM testb;
-- Bview 뷰를 사용해서 bid = 3    score = 70 수정.
UPDATE bView
SET score = 70
WHERE bid = 3;
--1 행 이(가) 업데이트되었습니다.
ROLLBACK;
--
CREATE OR REPLACE VIEW bView
AS
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
    WITH CHECK OPTION CONSTRAINT CK_bView_score;
-- View BVIEW이(가) 생성되었습니다.
DROP VIEW bView;

DROP TABLE testa;
DROP TABLE testb;
-------------------------------------------------------------------------------
-- MATERIALIZED VIEW (물리적 뷰)
-- [DB(데이터 베이스)모델링]
--1. 데이터베이스(Database) ? 서로 관련된 데이터의 모임(집합)
--2. DB 모델링 ? 현실 세계의 업무적인 프로세스를 물리적으로 BD화 시키는 과정
--    ex) 현실 세계의 업무적인 프로세스 (스타벅스에서 음료 주문)
--        (상품) 검색 → 주문 → 결제 → 대기 → 상품 픽업

--3. DB 모델링 과정 (단계, 순서)
--    1) 업무 프로세스                  → 2) 개념적 BD 모델링
--    (요구분석서 작성)                   (ERD 작성) exERD tool     --eXERD툴                                  
                
--            ↑                                    ↓
                                                
--     4) 물리적 DB 모델링          ←     3) 논리적 DB 모델링
--        DBMS                         (스키마, 정규화 과정)
--        타입, 크기 등등
--        인덱서
--        역정규화
--        등등

--4.프로젝트 진행 과정
-- ※ 계획 → 분석 → 설계 → 구현 → 테스트 → 유지보수
--( 1년 프로젝트 중 DataBase 모델링 6개월 정도 소요됨. )

--5. DB 모델링 단계(1) 업무 프로세스 분석 -> [요구사항 명세서 (분석서)] 작성
--    1) 관련 분야에 대한 기본 지식과 상식 필요
--    2) 신입 사원의 입장에서 업무 자체와 프로세스 파악, 분석 필요
--    3) 우선, 실제 문서(서류, 장표, 보고서 등등)를 수집하고 분석
--    4) 담당자 인터뷰, 설문 조사 등등 요구사항 직접 수렴
--    5) 비슷한 업무 처리하는 DB 모델링 분석
--    6) 백그라운드 프로세스 파악
https://terms.naver.com/entry.naver?docId=3431222&ref=y&cid=58430&categoryId=58430

--6. DB 모델링 단계( 6 ) 개념적 DB 모델링 -> [ERD] 작성
--1. 개념적 데이터 베이스 모델링이란 ?
--   데이터 베이스 모델링을 함에 있어 가장 먼저 해야될 일은 사용자가 필요로 하는 데이터가 무엇이며
--                      어떤 데이터를 데이터베이스에 담아야 하는 지에 대한 충분한 분석이다.
--   이러한 것들은 업무 분석, 사용자 요구 분석 등을 통해 얻어지며 수집된 현실 세계의 정보들을 사람들이 이해할 수 있는 
--   명확한 형태로 표현하는 단계를 '개념적 데이터베이스 모델링'이라고 한다.
--
--2. ER-Diagram
--   현실 세계를 좀 더 명확히 표현하기 위한 여러 방법 중 가장 널리 사용되고 있는 개체(E)-관계(R) 모델을 이용해
--   개념적 데이터베이스 모델리에 대해 알아보자.
--
--3. E-R Model
-- 1) 1976년 P.Chen이 제안한 것.
-- 2) 개체 관계 모델을 그래프 형식으로 알아보기 쉽게 표현한 것.
--     개체  - 직사각형,
--   속성 - 타원형,
--   개체들 간의 관계 - 마름모
--   이들을 연결하는 링크로 구성됨.
--
-- 3) 예 ( 학생과 과정 관계를 표현한 ER-Diagrm)
--
--   학생(사) - 학번(타) 식별자속성    - 전화번호(타) - 이름(타)
--      ↕
--   등록(마) 다대다 관계(N:M)
--       ↕
--   과정(사) - 과정코드(타)식별자속성     - 과정명(타) - 과정내용(타)
--
--4. ER - Diagrm 의 용어 
--   1) 실체(Entity)
--   2) 속성(Attribute)
--   3) 식별자(Identifier)
--   4) 관계(Relational)
--
--   
--   4-1.   실체(Entity)
--   1) 업무 수행을 위해 데이터로 관리되어져야 하는 사람,사물,장소,사건등을 '실체'라 한다.
--      이 때 구축하고자 하는 업무의 목적과 범위,전략에 따라 데이터로 관리되어져야 하는 항목을 파악하는 것이 매우 중요.
--   2) 실체는 학생,교수 등과 같이 물리적으로 존재하는 유형
--      과목,학과 등과 같이 개념적으로 존재하는 대상이 될 수 있다.
--    3) 실체는 테이블로 정의된다.
--   4) 실체는 인스턴스라 불리는 개별적인 객체들의 집합이다.
--    예) 과목 : 자료 구조, 데이터베이스, 프로그래밍 등의 인스턴스들의 집합.
--        학과 : 컴퓨터공학과, 전자공학, 국어교육학과 등의 인스턴스들의 집합.
--   5) 실체를 파악하는 요령 
--    - 관련 업무에 대한 지식( 가장 중요 )
--    예)
--     학원에서는 학생들의 출결상태와 성적들을 과목별로 관리하기를 원하고 있다.. (라고 업무 분석한 내용)
--     - 실체(명사들 파악) : 학원(체인점이 아니라면 뺀다 ), 학생, 출결상태,성적, 과목
--   -  각종 서류를 이용해서 실체 파악하는 것도 좋은 방법이다. 
--
--   4-2.   속성(Attribute)
--   1) 속성이란 ? 저장할 필요가 있는 실체에 대한 정보.
--      즉, 속성은 실체의 성질, 분류, 수량, 상태, 특성, 특징 등을 나타내는 세부 항목을 의미한다. 
--   2) 속성 설정 시 가장 중요한 부분은 관리의 목적과 활용 방향에 맞는 속성의 설정이다.
--   3) 속성의 숫자는 10개 내외로 하는 것이 좋다.
--   4) 속성은 컬럼으로 정의된다.
--   예)
--   학생이란 실체의 속성 ? 업무프로세스에 따라 달라짐.
--          학번, 이름, 주민번호, 전화번호,주소...
--   사원이란 실체의 속성 ?
--         사원번호, 사원명, 주민번호, 전화번호, 주소, 입사일자, 퇴사일자, 부서명...
--   5) 속성의 유형
--      (1) 기초 속성 : 원래 갖고 있는 속성
--      (2) 추출 속성 : 기초 속성으로 가공처리(계산)를 해서 얻어질 수 있는 속성
--                자료의 중복성,무결성 확보를 위해 최호화시키는 것이 바람직하다.
--      (3) 설계 속성 : 실제로 존재하지는 않으나 시스템의 효율성을 위해 설계자가 
--       임의로 부여하는 속성.
--   예)
--   주문 Entity
--   주문번호   고객   주문상품   주문일자   단가   수량   주문총금액   주문상태
--   1   홍길동   H302   0204   10000   3   600000      1
--   2   홍길동   H302   0204   10000   3   600000      1
--   3   홍길동   H302   0204   10000   3   600000      1
--
--   여기서)    추출속성 : 주문총금액 = 단가 * 수량    
--      설계속성 : 주문상태( 주문의 진행 상태:주문,결제완료,배송완료,취소) 확인 위한 속성
--
--   [쇼핑몰의 주문 프로세스]  
--    주문->취소->주문처리 완료
--        ->결제완료 -> 배송완료 -> 주문처리 완료.
--
--   6) 속성 도메인의 설정
--    - 속성이 가질 수 있는 값들의 범위, 다시 말해 속성에 대한 세부적인 업무 , 제약조건 및 특성을 
--      전체적으로 정의해 주는 것을 '속성의 도메인 설정'이라 한다.
--    - 도메인 설정은 추후 개발 및 실체를 데이터베이스로 생성할 때나 프로그램 구현 시 유용하게 사용하는 산출물이다.
--    - 도메인 정의 시에는 속성의 이름, 자료의 형태, 길이, 형식, 허용되는 값의 제약 조건, 유일성(Unique), 널 여부,
--      유효값,초기값들의 사항을 파악해주면 된다. 
--    - 도메인 무결성. : 데이터의 입력 형식이나 입력값등을 정의함으로써
--             잘못된 데이터가 입력되는 경우의 수를 방지    하기위해 설정하는 것. 
--
--   4-3.   식별자(Identifier)
--   1) 식별자란?
--      한 실체 내에서 각각의 인스턴스를 유일(Unique)하게 구분할 수 있는 단일 속성 또는 속성 그룹. 실체 무결성.
--   2) 식별자가 없으면 데이터를 수정/삭제 못한다.
--      그래서 모든 실체는 반드시 하나 이상의 식별자를 보여하여야하며 또한 여러 개의 식별자를 보유할 수 있다.
--   3) 식별자의 종류
--      (1) 후보키(Candidate Key)
--         실체에서 각각의 인스턴스를 구분할 수 있는 속성( 사원번호,주민번호) 
--      예) 사원 - 사원번호, 주민번호,사원명, 부서,주소
--          
--      (2) 기본키(Primary Key)
--         후보키 중 가장 적합한 키. ( 사원번호 )
--         - 해당 실체를 대표할 수 있나? 업무적으로 활용도가 높나? 길이가 짧나? 등등의 만족하는 후보키 중 하나 선택.
--         ( 중요 )
--           기본키는 not null, no duplicate(중복성),unique,clusterd index 설정됨.
--
--      (3) 대체키(Alternate Key)
--         후보키 중 기본키로 설정되지 않은 속성( 주민번호 )
--         - index(인덱스)로 활용됨. 
--
--      (4) 복합키(Composite Key)
--         하나의 속성으로 기본키가 될 수 없는 경우 둘 이상의 컬럼을 묶어서 식별자로 정의한 경우.
--         - 복합키 구성시 고려사항. : 복합키 중 어떤 컬럼을 먼저 둘것이냐? 
--            이유: 복합키 중 먼저오는 컬럼에 index,unique가 적용되기에 성능 고려 때문.
--      예) 급여 내역 실체
        
--      급여지급일   사번    지금일자   급여액
--      200901      1   30   10000   
--      200901      2   30   10000   
--      200902      1   30   10000   
--      200902      2   30   10000   
--      
--      위의 기본키는 ? 없다. 
--      복합키 : 급여지급일 + 사번 
--      고려할 점 ) 어떠한 컬럼(속성)을 먼저 둘까? 
--         - 조회의 경우 : 사번, 급여지급일 중 어느 컬럼으로 조회가 많나? 
--         - 조회수가 비슷하다면 데이터의 입력 순서로 결정 : 당연 급여지급일자  우선 
--            ( 아마 입력은 년/월/일 지급일자 순으로 계속 저장 될 것이다...)
--
--
--      (5) 대리키(Surrogate Key:서러게이트)
--         - 식별자가 너무 길거나 여러 개의 복합키로 구성되어 있는 경우 인위적으로 추가한 식별자(인공키).
--         - 이것도 역정규화 작업이다. 
--      예) 급여 내역 실체
--      일련번호   급여지급일   사번    지금일자   급여액
--      1   200901      1   30   10000   
--      2   200901      2   30   10000   
--      3   200902      1   30   10000   
--      4   200902      2   30   10000   
--   
--      - 일련번호라는 대리키를 추가해서 식별자로 사용. ( 성능,효율성 때문에 ) 
--
--   4-4.   관계(Relational)
--   - 관계란? 업무의 연관성이다.  실체를 정의하다보면 서로 연관되는 실체들이 있다. 
--   예)
--   비디오테이프      회원
--   관계) 
--      [대여관계]
--      회원은 비디오테이프를 대여한다.
--             비디오테이프는 회원에게 대여된다.
--      [가르침관계]
--      학생은 교수에게 가르침을받는다.
--      교수는 학생을 가르친다.
--
--   - 관계 표현(부여)
--   
--      회원(사)    실선   대여(마)  실선   비디오(사)
--      1) 관계가 있는 두 실체를 실선으로 연결하고 관계를 부여한다.
--     2) 관계 차수를 표현한다. ( 1:1, 1:N, N:M관계)
--     3) 선택성을 표시한다. 
--
--   4-4-1) 관계 차수
--      1) 1:1 관계
--       각각의 부서와 관리하는 부서장과의 관계.
-- 
--      1) 1:N 관계
--       각각의 부서와 사원과의 관계
--
--      1) N:M 관계
--        고객과 상품 실체 간에는 주문이라는 관계. 
--       ( 한 고객은 여러 상품을 주문할 수 있고, 한 상품은 여러 고객에게 주문될 수 있다.)
--
--       다대다 관계는 여러 문제점 때문에
--         논리적 데이터베이스 모델링 단계를 거치면서 1:N 관계로 바꾼다. 
--
--      실제 데이터베이스는 1:1과 1:다 관계만 존재한다. 

---------------------------------------------------------------------------
-- 예제
--[문제1] 다음은 현업 담담자와의 면담 자료이다. (요구분석)
--지금까지 알아본 개념을 바탕으로 다음에서 실체와 주요 속성을 추출해 다이어 그램을 그리시오.

--나는 교육센터의 관리자이다 우리는 여러 과정을 가르치는 데, 각 과정은 코드,이름 및 수강료를 갖고 있다. 
--'VB'과 'Java' 는 인기 있는 과정이다. 과정들은 1일~4일간으로 기간은 다양하다.
--박찬호와 박신양은 우리의 가장 훌륭한 강사들이다.
--우리는 각 강사의 이름과 전화번호를 필요로 한다. 학생들은 시간에 따라 여러 개의 과정을 이수할 수 있는 데 
--많은 학생들이 이렇게 하고 있다. 우리는 각 학생들의 이름과 전화번호를 알고 싶다. 

---------------------------------------------------------------------------
--7. DB 모델링 과정(3단계) - 논리적 DB 모델링 (논리적 스키마 생성, 정규화)
--    1) E-R 다이어그램 -> 릴레이션(테이블) 스키마로 변환
--    (5가지 규칙)
--    
--            이상 현상을 제거 하는 정규화가 논리적 모델
--    2) 정규화
--    ㄱ. 정규화 ? 이상 현상이 발생하지 않도록 하려면,
--           관련 있는 속성들로만 릴레이션을 구성해야 하는데 
--           이를 위해 필요한 것이 정규화
--    ㄴ. 함수적 종속성(FD;Functional Dependency) ?    속성들 간의 관련성    
--   
--   함수적 종속 ?
--   emp 테이블
--   empno(PK) ename    ename(Y)은 empno(X)에 함수적으로 종속된다.
--      X       Y
--    결정자    종속자
--      X   →   Y
--   
--   empno -> ename
--   empno -> hiredate
--   empno -> job
--   
--   empno -> (ename, job, mgr, hiredate, sal ,comm, deptno )
--      
--   SELECT *    
--   FROM emp;
--   (1) 완전 함수적 종속
--       여러 개의 속성이 모여서 하나의 기본키(PK)를 이룰 때   == 복합키
--       복합키 전체에 어떤 속성이 종속적일 때 "완전 함수적 종속"이라고 한다. 
--       예)   복합키
--       (고객ID + 이벤트번호)    ->    당첨여부
--       
--   (2) 부분 함수적 종속 ( 복합키 ) 
--       완전 함수 종속이 아니면 "부분 함수적 종속" 이라고 한다. 
--        예)  복합키
--       (고객ID + 이벤트번호)    ->    고객이름  X
--        고객ID                ->    고객이름 
--             
--        고객테이블
--        PK
--        고객ID 고객이름
--        
--   (3) 이행 함수적 종속
--     Y는 X에 함수적 종속이다.
--     결정자 종속자       결정자     종속자
--      X      ->  Y          Y     ->   Z          일때    X  ->    Z
--     empno   -> deptno    deptno -> dname 
--                ename
--     [사원테이블]
--     사원번호  사원명  부서번호  부서명 
--      PK
---------------------------------------------------------------------------
    [ BCNF ] 정규화
    복합키
    A   →   C   완전 함수적 종속
    [B] ←   
    
    A   C
    C   B
