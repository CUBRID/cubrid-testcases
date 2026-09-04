-- CBRD-27365 TC04: CONNECT BY (ORDER SIBLINGS BY 문자열 키·다중 루트·DELETE IN 서브쿼리·ISLEAF/ISCYCLE in-place)
-- 목적: 계층 정렬(bf2df_str_compare, D-191-1 경계 밖 읽기 회귀)·다중 루트 recalc 레벨(-495 회귀)·in-place 덮어쓰기 5지점 중 3지점.
DROP TABLE IF EXISTS t04;
CREATE TABLE t04 (id INT PRIMARY KEY, pid INT, name VARCHAR(20), w INT);
INSERT INTO t04 VALUES (1, NULL, 'root-a', 10), (2, NULL, 'root-b', 20), (3, 1, 'a1', 1), (4, 1, 'a2', 2), (5, 3, 'a11', 3), (6, 3, 'a12', 4), (7, 2, 'b1', 5), (8, 7, 'b11', 6), (9, 8, 'b111', 7), (10, 4, 'a21', 8);
INSERT INTO t04 VALUES (11, 1, 'a3-long-sibling-name', 9), (12, 1, 'a', 11), (13, 1, '', 12);
-- START WITH 있는 단일/다중 루트 + ORDER SIBLINGS BY 문자열(길이가 다른 형제 이름)
SELECT LEVEL, id, pid, name, CONNECT_BY_ISLEAF, SYS_CONNECT_BY_PATH(name, '/') AS path FROM t04 START WITH pid IS NULL CONNECT BY PRIOR id = pid ORDER SIBLINGS BY name;
-- START WITH 없는 다중 루트(모든 행이 루트) — -495 재현 형태
SELECT LEVEL, id, name FROM t04 CONNECT BY PRIOR id = pid ORDER SIBLINGS BY name, id;
SELECT COUNT(*) FROM t04 CONNECT BY PRIOR id = pid;
-- ISLEAF / ISCYCLE (NOCYCLE 로 사이클 행 마킹) — in-place 덮어쓰기 지점
UPDATE t04 SET pid = 9 WHERE id = 2;
SELECT LEVEL, id, name, CONNECT_BY_ISLEAF, CONNECT_BY_ISCYCLE FROM t04 START WITH id = 2 CONNECT BY NOCYCLE PRIOR id = pid ORDER SIBLINGS BY name;
UPDATE t04 SET pid = NULL WHERE id = 2;
-- 계층 + 가변 컬럼 앞의 in-place 값(ISLEAF 가 가변 name 뒤에 오도록 컬럼 순서 변경)
SELECT name, CONNECT_BY_ISLEAF, LEVEL, id FROM t04 START WITH id = 1 CONNECT BY PRIOR id = pid ORDER SIBLINGS BY w DESC;
-- CONNECT_BY_ROOT / PRIOR 표현식 + WHERE 필터
SELECT id, CONNECT_BY_ROOT name AS root_name, PRIOR name AS parent_name, LEVEL FROM t04 WHERE LEVEL >= 3 START WITH pid IS NULL CONNECT BY PRIOR id = pid ORDER BY id;
-- DELETE ... IN (계층 서브쿼리) — 다중 루트 + 정렬 (D-191-1 회귀)
DELETE FROM t04 WHERE id IN (SELECT id FROM t04 CONNECT BY PRIOR id = pid ORDER SIBLINGS BY name);
SELECT COUNT(*) FROM t04;
DROP TABLE t04;
