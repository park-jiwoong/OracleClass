-- SYS --
SELECT *
FROM all_tables
--FROM all_tables
WHERE table_name = LIKE 'DUAL';
--
DESC dual;
-- DUMMY VAARCHAR2(1) 컬럼 1개
SELECT *
FROM dual;
-- 1개의 행만 있다
SELECT *
FROM scott.emp; -- Schema.emp를 사용해야함
--[Schema.dual]?
SELECT * FROM all_synonyms
WHERE synonym_name LIKE UPPER('dual');


-- SYS
SELECT *
FROM scott.emp; -- scott.emp -> arirnag 시노님
-- 시노님 생성, 삭제 : DBA만 가능
[형식]
CREATE [public] SYNONYM [schema.]synonym명
FOR [schema.]object명;
--
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;
--SYNONTM ARIRANG이(가) 생성되었습니다
SELECT *
FROM arirang;
FROM scott.emp;
-- emp 테이블의 소유자 (owner) 확인
SELECT *
FROM all_tables
WHERE table_name = 'EMP';

-- PUBLIC 시노님을 삭제 : DBA 만 가능
[형식]
    DROP [PUBLIC] SYNONYM synonym명;
    --
    DROP PUBLIC SYNONYM ariring;
--    시노님 목록 조회해서 정말 삭제되었는지 확인... 퀄리 작성
    SELECT *
    FROM all_synonyms
    WHERE sysnonym_name = 'ARIRANG';
    