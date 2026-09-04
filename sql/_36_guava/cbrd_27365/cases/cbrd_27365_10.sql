-- CBRD-27365 TC10: in-place 덮어쓰기 5지점 — ORDERBY_NUM / INST_NUM(ROWNUM) / CONNECT_BY_ISLEAF·ISCYCLE / parent_pos, 가변 컬럼 뒤에 대상 컬럼
-- 목적: bound·동일 크기 계약(#185) 하에서 가변 컬럼(비상수 오프셋) 뒤에 있는 대상 값을 접근자가 정확히 덮어쓰는지.
DROP TABLE IF EXISTS t10;
CREATE TABLE t10 (id INT, pid INT, name VARCHAR(30), n NUMERIC(10,2), tag CHAR(2));
INSERT INTO t10 VALUES (1, NULL, 'root', 1.0, 'aa'), (2, 1, 'child-long-name-2', 2.0, NULL), (3, 1, 'c3', NULL, 'cc'), (4, 2, '', 4.0, 'dd'), (5, 2, 'child-5', 5.0, 'ee'), (6, 3, NULL, 6.0, 'ff'), (7, NULL, 'root2', 7.0, 'gg'), (8, 7, 'x', 8.0, 'hh');
-- ORDERBY_NUM: 가변 name 뒤 열, 정렬 뒤 번호 매기기 + FOR 필터
SELECT name, ORDERBY_NUM() AS obn, n, tag FROM t10 ORDER BY n DESC FOR ORDERBY_NUM() BETWEEN 2 AND 6;
SELECT ORDERBY_NUM(), name, tag FROM t10 ORDER BY name FOR ORDERBY_NUM() <= 4;
-- INST_NUM / ROWNUM: 서브쿼리 리스트 위에서
SELECT ROWNUM AS rn, name, n FROM (SELECT name, n FROM t10 ORDER BY id DESC) s WHERE ROWNUM <= 5;
SELECT name, INST_NUM() AS inum, tag FROM t10 WHERE INST_NUM() BETWEEN 2 AND 5 ORDER BY id;
-- 병렬 스캔 경로 inst_num(px_scan_instnum): 큰 테이블 없어도 ROWNUM 조건 + 병렬 힌트 유무 대조
SELECT /*+ NO_PARALLEL */ COUNT(*) FROM (SELECT name FROM t10 WHERE ROWNUM <= 3) s;
SELECT COUNT(*) FROM (SELECT name FROM t10 WHERE ROWNUM <= 3) s;
-- CONNECT BY: ISLEAF / ISCYCLE / parent_pos 가 가변 name·NUMERIC 뒤
SELECT name, n, tag, CONNECT_BY_ISLEAF, CONNECT_BY_ISCYCLE, LEVEL FROM t10 START WITH pid IS NULL CONNECT BY NOCYCLE PRIOR id = pid ORDER SIBLINGS BY name;
UPDATE t10 SET pid = 5 WHERE id = 1;
SELECT name, tag, CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, LEVEL FROM t10 START WITH id = 1 CONNECT BY NOCYCLE PRIOR id = pid ORDER SIBLINGS BY name;
UPDATE t10 SET pid = NULL WHERE id = 1;
-- ORDERBY_NUM + CONNECT BY 조합
SELECT ORDERBY_NUM(), name, LEVEL FROM t10 START WITH pid IS NULL CONNECT BY PRIOR id = pid ORDER BY LEVEL DESC, name FOR ORDERBY_NUM() <= 5;
DROP TABLE t10;
