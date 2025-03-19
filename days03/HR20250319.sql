-- HR --
SELECT * -- emp 테이블의 모든 칼럼
FROM scott.emp; -- 시노님

FROM user tables;
--employees 사원 테이블 조회
--[문제] 사원번호, 사원명, 입사일자 만 조회

SELECT * FROM user_tables;

EMPLOYEES
SELECT * emlpoyee_id,
--,first name, last_name
--,first_name + last_name
    ,'Hello || 'world'
    ,CONCAT( CONCAT(first_name, ' '), last_name ) "full name"
 
    , hire_date

FROM employees;

select EMPLOYEE_ID, 
--FIRST_NAME, LAST_NAME, 
--FIRST_NAME + LAST_NAME AS "NAME",
--FIRST_NAME || ' ' || LAST_NAME AS "NAME", 
CONCAT( CONCAT(first_name, ' '), last_name ) "full name" , 
'hello' || 'world',
HIRE_DATE

FROM EMPLOYEES;

--
SELECT * --last_naem, salary
FROM employees
WHERE last_name LIKE '%a\_b%' ESCAPE '\'
--WHERE last_name LIKE 'a_b%'
--WHERE last_name LIKE '%a_b%'
--WHERE last_name LIKE '%A\_B%' ESCAPE '\'
--(★ 점심시간 질문 대기 ★)
ORDER BY salary;
-- employee_id 사원번호 154 lsat_name ('Cambrault' → 수정 'a_braukt')
--DML 문 - INDERT, UPDATE, DELETE
UPDATE employees
SET last_name = 'a_braukt'
WHERE employee_id = 154;
--
UPDATE 테이블명
SET 수정할컬럼 = 값...
WHERE 수정조건

--[문제]  100,101,102 사원의 last_name
100   Steven   K%ing
101   Neena   Koch%har
102   Lex   De Ha%an

UPDATE employees
SET last_name = 'K%ing'
WHERE employee_id = 100;

UPDATE employees
SET last_name = 'Koch%har'
WHERE employee_id = 101;

UPDATE employees
SET last_name = 'De Ha%an'
WHERE employee_id = 102;


-- [문제] last_name 속에 %가 있는 사원의 정보를 조회

SELECT * FROM employees WHERE last_name like '%\%%' ESCAPE '\'
rollback;

--REGEXP_LIKE 함수

--RDAP() 함수예제
--오라클 나눗셈 연산자   /   자바 X    소수점 아래도 출력...
select last_name, rpad(' ', salary/1000/1, '*') "Salary", salary
from EMPLOYEES
where department_id = 80
order by last_name, "Salary";

-- (풀이)
SELECT last_name
--        ,salary
--        ,salary/1000+1
--        ,ROUND( salary/1000)
          ,RPAD( ' ' ,ROUND (salary/1000)+1, '#' ) "Salray2"
FROM employees
WHERE department_id = 80;
ORDER BY last_name, "salary2" -- 2차 정렬 하겠다는 뜻
-- 풀이는 막대 그래프로 나타내겠다

SELECT deptno, ename, sal
FROM emp
ORDER BY 1, 3 DESC;
ORDER BY deptno ASC, sal DESC;
ORDER BY deptno ASC, ename ASC;
-- REGEXP_REPLACE 예제 --515.123.4567 → (515) 123-4567

SELECT REGEXP_REPLACE(phone_number,
    '([[:digit:]]{3})\.([[:digit:]]{3})\.([[:digit:]]{4})',
    '(\1) \2-\3') "REGEXP_REPLACE", phone_number
from employees
order by "REGEXP_REPLACE";

-- 쿼리 이해~
SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '([aeiou])\1','i')
ORDER BY last_name;
