
SELECT
    sa.aContent AS "항목 내용",         -- 답변 항목 내용
    COUNT(v.vid) AS "득표수",           -- 해당 항목의 실제 득표수 계산
    -- RPAD 함수를 이용한 텍스트 그래프 생성
    -- RPAD('채울문자', 득표수, '채울문자')
    -- 여기서는 계산된 득표수(COUNT(v.vid))만큼 '■' 문자를 반복합니다.
    RPAD('■',                         -- 그래프를 구성할 문자
         COUNT(v.vid),                 -- 그래프 길이 = 실제 득표수
         '■') AS "결과 그래프"        -- ■ 문자로 채워진 그래프
FROM
    SurveyAnswer sa                 -- 기준 테이블: 답변 항목
LEFT JOIN                           -- 투표 기록 테이블 LEFT JOIN (0표인 항목도 포함)
    vote v ON sa.aid = v.aid
WHERE
    sa.sid = :selected_sid          -- <--- 여기에 조회할 설문 ID 입력
GROUP BY
    sa.aid, sa.aContent             -- 항목 ID와 내용으로 그룹화하여 득표수 계산
ORDER BY sa.aid;                         -- 답변 항목 ID 순서로 정렬
