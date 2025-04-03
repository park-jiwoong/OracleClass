-- PL/SQL 
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P';
--
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '관리자', '010-1111-1111', '서울 강남구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  '홍길동', '010-1111-1112', '서울 동작구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '김준석', '010-1111-1341', '경기 남양주시' );
    COMMIT;
--
  SELECT * 
  FROM t_member;
 -- 
  ㄹ. 회원 정보 수정
  로그인 -> (홍길동) -> [내 정보] -> 내 정보 보기 -> [수정] -> [이름][][][][][][] -> [저장]
  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
  ㅁ. 회원 탈퇴
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
--
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte, ItemCount, PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'좋아하는 여배우?'
                          , TO_DATE( '2025-03-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2025-03-30 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5
                          , 0
                          , TO_DATE( '2025-01-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'배슬기', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'김옥빈', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'아이유', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'김선아', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'홍길동', 0, 1 );      
   COMMIT;
--
 INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 2  ,'좋아하는 과목?'
                          , TO_DATE( '2025-04-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2025-04-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 4
                          , 0
                          , TO_DATE( '2024-03-21 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'자바', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'오라클', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
   
   COMMIT;
--
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'좋아하는 색?'
                          , TO_DATE( '2025-04-11 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2025-04-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2025-04-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );

INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'파랑', 0, 3 ); 
   
   COMMIT;                    
--
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일
         , itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '시작 전';  
-- 
SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '종료'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
                  ELSE '시작 전'
               END 상태
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
--
  SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
--
SELECT  polltotal  
FROM t_poll
WHERE pollseq = 2;
    -- 
SELECT answer, acount
    , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
    -- ,  막대그래프
    , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
 FROM t_pollsub
WHERE pollseq = 1;
select *
from t_member;
--
 INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      3   ,  '김준석'      , SYSDATE,   1  ,     3 ,        3 );
    COMMIT;
  -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 1;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 3;
    
    commit;
-- [PL/SQL] --------------------------------------------------------------------
[ DECLARE ] -- 익명 프로시저
    -- 선언문(declarations) 선언블럭 : 변수 선언, 상수 선언
    
    BEGIN          
    -- 실행문(statements)   실행블럭 : 
                                        SELECT;
                                        SELECT;
                                        :
                                        INSERT;
                                        INSERT;
                                        :
                                        UPDATE;
                                        UPDATE;
                                        :
                                        DELETE;
                                        DELETE;
                                        DELETE;
                                        :                  
                                        
[ EXCEPTION ]   -- 예외 처리문(handlers) (예외처리블럭)
   END;
--
BEGIN
END;
-- 익명 프로시저 선언
desc emp;

DECLARE
    -- 선언블럭 : [사원이름, 급여 저장할 변수], 상수
    -- vename VARCHAR2(10); -- 세미콜론(;
    -- %TYPE형 변수로 수정
    vename emp.ename%TYPE;
    
    vpay NUMBER          ;
    -- 상수선언 PI
    --FINAL double PI = 3.141592 (JAVA에서)
    VPI CONSTANT NUMBER := 3.141592; --(오라클에서)
BEGIN
    -- 실행블럭
    SELECT ename, sal + NVL(comm, 0) pay
        INTO vename, vpay
    FROM emp
    WHERE empno = 7369;
    --  PUT(), PUT_LINE()
    --  print(), println()
    DBMS_OUTPUT.PUT_LINE(vename||', '||vpay);
--EXCEPTION
--PL/SQL 프로시저가 성공적으로 완료되었습니다.
END;
--[문제] 30번 부서의 지역명을 얻어와서
-- 10번 부서의 지역명으로 설정하는 익명 프로시저 작성 + 테스트

UPDATE dept
SELECT loc
SET loc = (
    SELECT loc
    FROM dept
    WHERE deptno = 30;
)
WHERE deptno = 10;

-- 익명프로시져
DECLARE
    vloc dept.loc%TYPE;
BEGIN
    --1)
    SELECT loc
    FROM dept
    WHERE deptno = 30;
    --2)
    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
    --      COMMIT;
--EXCEPTION
    -- ROLLBACK;
END;
--
ROLLBACK;
--
SELECT * FROM dept;
--[문제] 30번 부서원들 중에 최고 급여(pay)를 받는 사원의
--정보를 출력하는 쿼리 작성
-- (empno, ename, hiredate, job, sal, comm)
-- 1) PL/SQL X
    --a. TOP-N 방식
    SELECT empno, ename, hiredate, job, sal, comm
    FROM (
        select empno, ename, hiredate, job, sal, comm
        from emp
        where deptno = 30
        order by sal + NVL(comm, 0)
    )
WHERE ROWNUM = 1;
    
    --b. RANK 함수 OK
    
    SELECT empno, ename, hiredate, job, sal, comm
    FROM (
        select empno, ename, hiredate, job, sal, comm,
            rank() over(order by  sal+NVL(comm,0)desc) salrank
        from emp
        where deptno = 30
    )
    WHERE salrank = 1;
    
    --c. 서브쿼리
    SELECT *
FROM emp
WHERE deptno = 10 AND sal = (
                        SELECT MAX(sal)
                        FROM emp
                        WHERE deptno = 10 );
    
    desc emp;
--------------------------------------------------------------------------------
-- 2) PL/SQL 익명프로시저 사용
DECLARE
    vmaxpay NUMBER;
    vdeptno emp.deptno%TYPE := 30;
    vempno emp.empno%TYPE;
    vname emp.ename%TYPE;
    vhiredate emp.hiredate%TYPE;
    vjob emp.job%TYPE;
    vsal emp.sal%TYPE;
    vcomm emp.comm%TYPE;
BEGIN
    --1) 30번 부서에서 최고 급여액 조회 -- 2850
    SELECT MAX(sal +NVL(comm, 0) ) INTO vmaxpay
    FROM emp
    WHERE deptno = vdeptno;
    --2)
    SELECT empno, ename, hiredate, job, sal, comm
    FROM EMP
    WHERE deptno = 10 ) AND sal+NVL(comm, 0) = vmaxpay;
    
    DBMS_OUTPUT.PUT LINE('사원번호 :' || vempno);
    DBMS_OUTPUT.PUT LINE('사원명 :' || vname);
    DBMS_OUTPUT.PUT LINE('입사일자 :' || vhiredate);
    
    
    --EXCEPTION
    END;
------------------------------------------------
-- 2-2) PL/SQL 익명프로시저 사용  + ( %ROWTYPE변수 )
DECLARE
   vmaxpay NUMBER;
   vdeptno dept.deptno%TYPE := 30 ;
   
   vemprow emp%ROWTYPE;
BEGIN
  -- 1) 30번 부서에서  최고 급여액 조회 -- 2850
  SELECT MAX(  sal + NVL(comm, 0)  ) INTO vmaxpay
  FROM emp
  WHERE  deptno = vdeptno;
  -- 2)
  SELECT  empno, ename, hiredate, job, sal, comm
     INTO vemprow.empno, vemprow.ename
     , vemprow.hiredate, vemprow.job, vemprow.sal
     , vemprow.comm
  FROM emp
  WHERE deptno = vdeptno AND sal+NVL(comm,0) = vmaxpay;
  
  DBMS_OUTPUT.PUT_LINE( '> 사원번호 :'  || vemprow.empno );
  DBMS_OUTPUT.PUT_LINE( '> 사원명 :'    || vemprow.ename );
  DBMS_OUTPUT.PUT_LINE( '> 입사일자 :'  || vemprow.hiredate );   
--EXCEPTION
END;

--0
--
DECLARE 
   vename emp.ename%TYPE; 
   vpay NUMBER         ; 
BEGIN --CURSOR 선언 ⇒ OPEN ⇒ FETCH ⇒ CLOSE
   SELECT ename , sal + NVL(comm, 0) pay
        INTO vename, vpay
   FROM emp;
   --WHERE empno = 7369; 
   DBMS_OUTPUT.PUT_LINE( vename || ', ' || vpay);
--EXCEPTION
END;
--ORA-00933: SQL command not properly ended
--ORA-06550: line 5, column 4:

--ORA-01422: exact fetch returns more than requested number of rows
--ORA-06512: at line 5

-- [만약]
--CURSOR 선언 ⇒ OPEN ⇒ FETCH ⇒ CLOSE

-- := 대입 연산자
DECLARE
    va NUMBER := 10;
    vb NUMBER;
    vc NUMBER;
BEGIN
    vb := 20;
    vc := va + vb;
    DBMS_OUTPUT.PUT_LINE(va|| '+' || vb || '=' || vc);
-- EXCEPTION
END;

--------------------------------------------------------------------------------
-- PL/SQL : 제어문 
if(조건식) {
    if(// 명령코딩) {
    } //
}

IF 조건식 THEN
END IF;
----------------

if(조건식) {
} else {
}

IF 조건식 THEN
ELSE
END IF;
----------------
if(조건식){
}else if(조건식){
}else if(조건식){
}else if(조건식){
}else if(조건식){
}else{
}

IF 조건식 THEN
ELSIF 조건식 THEN 
ELSIF 조건식 THEN 
ELSIF 조건식 THEN 
ELSE
END IF;

--[문제] 정수를 입력받아서 변수에 대입하고
--  홀수/짝수 라고 출력
DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6); --byte 자료형 오류
BEGIN
    vnum := :bindNumber; -- 바인드변수
    IF mod(vnum, 2) = 0 THEN vresult := '짝수';
    ELSE vresult := '홀수';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);

--EXCEPTION
END;
-----------------------------------------------
-- [문제] PL/SQL IF문 사용해서 
-- 국어점수를 입력받아서   수/우/미/양/가 출력 ( 익명 프로시저 )
DECLARE
   vkor NUMBER(3) := 0;
   vgrade VARCHAR2(3);
BEGIN
   vkor := :bindNumber; -- 바인드변수   
   
   IF vkor BETWEEN 0 AND 100 THEN  --CASE 구문도 사용 가능
      IF vkor >= 90 THEN 
          vgrade := '수';
      ELSIF vkor >= 80 THEN 
          vgrade := '우';
      ELSIF vkor >= 70 THEN 
          vgrade := '미';
      ELSIF vkor >= 60 THEN 
          vgrade := '양';
      ELSE 
          vgrade := '가';
      END IF;
      
   ELSE
     RAISE_APPLICATION_ERROR(-20009, '> ScoreOutOfBound Exception.');
   END IF;
   
   DBMS_OUTPUT.PUT_LINE(vgrade);
EXCEPTION
  WHEN OTHERS THEN  
     DBMS_OUTPUT.PUT_LINE('점수 입력 잘못(0~100)!!!');
END;

--------------------------------------------------------------------------------
while(조건식){
    //명령코딩;
}

WHILE 조건식
LOOP
    명령코딩;
END LOOP;
--
while(true){
    if(참) break;
}

LOOP
    //명령코딩;
        EXIT WHEN;

-- [문제] 1~10까지의 합 출력 ( PL/SQL + WHILE 문 )
-- 출력형식 )  1+2+3+..+8+9+10=55
DECLARE
   vi NUMBER(2) := 1;
   vsum NUMBER(3) := 0;
BEGIN
   WHILE ( vi <= 10 )  
   LOOP
      IF vi = 10 THEN
        DBMS_OUTPUT.PUT(vi);
      ELSE
        DBMS_OUTPUT.PUT(vi || '+');
      END IF;      
      vsum := vsum + vi;
      vi := vi + 1;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE( '=' ||  vsum);
--EXCEPTION
END;

-- [문제] 1~10까지의 합 출력 ( PL/SQL + LOOP END 문 )
-- 출력형식 )  1+2+3+..+8+9+10=55
DECLARE
   vi NUMBER(2) := 1;
   vsum NUMBER(3) := 0;
BEGIN
   LOOP
    EXIT WHEN vi > 10;
      IF vi = 10 THEN
        DBMS_OUTPUT.PUT(vi);
      ELSE
        DBMS_OUTPUT.PUT(vi || '+');
      END IF;      
      vsum := vsum + vi;
      vi := vi + 1;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE( '=' ||  vsum);
--EXCEPTION
END;

--------------------------------------------------------------------------------

DECLARE
--   vi NUMBER(2) := 1;
   vsum NUMBER(3) := 0;
BEGIN
   FOR vi IN 1..10 
   LOOP
     IF vi = 10 THEN
        DBMS_OUTPUT.PUT(vi);
      ELSE
        DBMS_OUTPUT.PUT(vi || '+');
      END IF;      
      vsum := vsum + vi;
   END LOOP;     
   DBMS_OUTPUT.PUT_LINE( '=' ||  vsum);
--EXCEPTION
END;

-- [GOTO 문] --
DECLARE
    vchk NUMBER := 0;
BEGIN
  --강제로 이동
  <<TOP>>
    vchk := vchk + 1;
    DBMS_OUTPUT.PUT_LINE(vchk);
    IF vchk != 5 THEN
        GOTO TOP;
    END IF;
--EXCEPTION
END;

-----------------
--DECLARE
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 2 처리 ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 1 처리 ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 3 처리 '); 
--EXCEPTION
END;

--[문제] WHILE문 사용 구구단 2~9단 (가로)
--각 단(2단, 3단, ...)을 한 줄에 가로로 출력
DECLARE
    vdan        NUMBER := 2; -- 시작 단 (2단)
    vmultiplier NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 구구단 (WHILE, 가로) ---');
    WHILE vdan <= 9 LOOP -- 바깥쪽 루프: 단 (2 ~ 9)
        vmultiplier := 1; -- 각 단을 시작할 때 곱하는 수를 1로 초기화
        WHILE vmultiplier <= 9 LOOP -- 안쪽 루프: 곱하는 수 (1 ~ 9)
            -- 결과값을 오른쪽 정렬하여 2자리로 표시 (LPAD 사용)
            DBMS_OUTPUT.PUT(vdan || '*' || vmultiplier || '=' || LPAD(vdan * vmultiplier, 2) || '  ');
            vmultiplier := vmultiplier + 1; -- 곱하는 수 증가
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- 한 단 출력이 끝나면 줄바꿈
        vdan := vdan + 1; -- 다음 단으로 증가
    END LOOP;
END;
/

--[문제] WHILE문 사용 구구단 2~9단 (세로)
-- 같은 곱하는 수(예: x 1, x 2, ...)에 대한 모든 단의 결과를 한 줄에 가로로 출력하고, 다음 곱하는 수로 넘어갑니다.
DECLARE
    vmultiplier NUMBER := 1; -- 시작 곱하는 수 (1)
    vdan        NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 구구단 (WHILE, 세로) ---');
    WHILE vmultiplier <= 9 LOOP -- 바깥쪽 루프: 곱하는 수 (1 ~ 9)
        vdan := 2; -- 각 곱하는 수를 시작할 때 단을 2로 초기화
        WHILE vdan <= 9 LOOP -- 안쪽 루프: 단 (2 ~ 9)
            DBMS_OUTPUT.PUT(vdan || '*' || vmultiplier || '=' || LPAD(vdan * vmultiplier, 2) || '  ');
            vdan := vdan + 1; -- 다음 단으로 증가
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- 해당 곱하는 수에 대한 모든 단 출력이 끝나면 줄바꿈
        vmultiplier := vmultiplier + 1; -- 다음 곱하는 수로 증가
    END LOOP;
END;
/

--[문제] FOR문 사용 구구단 2~9단 (가로)
--FOR 루프는 카운터 변수의 선언, 초기화, 증가, 조건 검사를 자동으로 처리하여 코드가 더 간결
DECLARE
    vmultiplier NUMBER := 1; -- 시작 곱하는 수 (1)
    vdan        NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 구구단 (FOR, 가로) ---');
    FOR vdan IN 2..9 LOOP -- 바깥쪽 루프: 단 (2 ~ 9)
        FOR vmultiplier IN 1..9 LOOP -- 안쪽 루프: 곱하는 수 (1 ~ 9)
            DBMS_OUTPUT.PUT(vdan || '*' || vmultiplier || '=' || LPAD(vdan * vmultiplier, 2) || '  ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- 한 단 출력이 끝나면 줄바꿈
    END LOOP;
END;
/

--[문제] FOR문 사용 구구단 2~9단 (세로)
DECLARE
    vmultiplier NUMBER := 1; -- 시작 곱하는 수 (1)
    vdan        NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 구구단 (FOR, 세로) ---');
    FOR vmultiplier IN 1..9 LOOP -- 바깥쪽 루프: 곱하는 수 (1 ~ 9)
        FOR vdan IN 2..9 LOOP -- 안쪽 루프: 단 (2 ~ 9)
            DBMS_OUTPUT.PUT(vdan || '*' || vmultiplier || '=' || LPAD(vdan * vmultiplier, 2) || '  ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- 해당 곱하는 수에 대한 모든 단 출력이 끝나면 줄바꿈
    END LOOP;
END;
/


-- 계층적 질의/시퀀스 정리
-- 동적쿼리
-- 작업스케줄
-- 암호화
-- 인덱서
-- 등등

-- while문 가로
declare
    dan number := 2;
    num number;
begin
    while dan <= 9
    loop
        num := 1;
        while num <= 9
        loop
        dbms_output.put(rpad(dan || 'X' || num || '=' || dan * num, 10));
        num := num + 1;
        end loop;
        dbms_output.put_line('');
        dan := dan + 1;
        end loop;
    end;

-- while[세로]
DECLARE
    vdan number(2) := 2;
    vx number(2) := 1;
BEGIN
    WHILE (vx <= 9)
    LOOP 
        vdan := 2;
        WHILE ( vdan <= 9)
        LOOP
          DBMS_OUTPUT.PUT(RPAD(vdan||'*'||vx || '=' || vdan * vx , 10)); 
          vdan := vdan + 1;
        END LOOP;
      vx := vx + 1;
      DBMS_OUTPUT.PUT_line(' '); 
    END LOOP;
END;


-- for문 가로
DECLARE
  vdan NUMBER := 2;
  vnum NUMBER;
  vres NUMBER;
BEGIN
  FOR vdan IN 2..9 LOOP
    FOR vnum IN 1..9 LOOP
      vres := vdan * vnum;
      IF vres < 10 THEN
        DBMS_OUTPUT.PUT(vdan || ' * ' || vnum || ' =  ' || vres || '    '); -- 한 자리 수일 경우 앞에 공백 추가
      ELSE
        DBMS_OUTPUT.PUT(vdan || ' * ' || vnum || ' = ' || vres || '    ');
      END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END;

-- for문 세로
DECLARE
    vdan NUMBER := 2;
    vnum NUMBER;
    vres NUMBER;
BEGIN
  FOR vnum IN 1..9 LOOP
    FOR vdan IN 2..9 LOOP
        vres := vdan * vnum;
        IF vres < 10 THEN
            DBMS_OUTPUT.PUT(vdan || ' * ' || vnum || ' =  ' || vres || '    '); -- 한 자리 수일 경우 앞에 공백 추가
        ELSE
            DBMS_OUTPUT.PUT(vdan || ' * ' || vnum || ' = ' || vres || '    ');
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END;



