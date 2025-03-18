-- HR --
SELECT *  
FROM scott.emp;  -- 시노님
-- HR이 소유하고 있는 테이블 목록 조회.
SELECT *
FROM user_tables;

-- Java   : 문자열 연결 연산자   +, String.concat() 메서드
-- Oracle : 문자열 연결 연산자  ||,       함수
-- employees 사원 테이블 조회
-- [문제] 사원번호, 사원명, 입사일자 만 조회.
SELECT employee_id
--    , first_name, last_name  
--    , first_name  || ' ' || last_name  AS "NAME"
--    , first_name  || ' ' || last_name  "NAME"
      , first_name  || ' ' || last_name  "full name"
      , first_name  || ' ' || last_name  name
--    , 'Hello'  || ' '  ||   'World'  -- 오라클 문자 또는 문자열  
      , CONCAT(  CONCAT(first_name, ' '), last_name )
      , hire_date
FROM employees;



