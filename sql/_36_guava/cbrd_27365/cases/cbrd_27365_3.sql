-- CBRD-27365 TC03: 오버플로 튜플(페이지보다 큰 튜플) + 큰 가변 값 정렬/집계
-- 목적: 리스트 페이지를 넘는 튜플(오버플로 페이지 체인)에서 새 포맷 헤더 len(4B, bit31 has-null)·비트맵·4B 가변 헤더 왕복.
DROP TABLE IF EXISTS t03;
CREATE TABLE t03 (id INT, k VARCHAR(10), v1 VARCHAR(30000), v2 VARCHAR(30000), n INT);
INSERT INTO t03 VALUES (1, 'k1', REPEAT('a', 20000), REPEAT('b', 20000), 1);
INSERT INTO t03 VALUES (2, 'k2', REPEAT('c', 25000), NULL, 2);
INSERT INTO t03 VALUES (3, 'k1', NULL, REPEAT('d', 30000), 3);
INSERT INTO t03 VALUES (4, 'k3', REPEAT('e', 16000), REPEAT('f', 16000), NULL);
INSERT INTO t03 VALUES (5, NULL, REPEAT('g', 100), REPEAT('h', 100), 5);
INSERT INTO t03 VALUES (6, 'k2', '', '', 6);
-- 오버플로 튜플 정렬(값이 오버플로 페이지에 놓임)
SELECT id, k, LENGTH(v1), LENGTH(v2), n FROM t03 ORDER BY k, id;
SELECT id, LENGTH(v1), LENGTH(v2), SUBSTR(v1, 19998, 3), SUBSTR(v2, 29998, 3) FROM t03 ORDER BY n DESC, id;
-- 큰 값 자체를 정렬키로
SELECT id, LENGTH(v1) FROM t03 ORDER BY v1, id;
-- 그룹 집계 with 오버플로 값 통과
SELECT k, COUNT(*), MAX(LENGTH(v1)), MIN(LENGTH(v2)) FROM t03 GROUP BY k ORDER BY k;
-- DISTINCT 에 오버플로 값 포함
SELECT DISTINCT SUBSTR(v1, 1, 1), LENGTH(v2) FROM t03 ORDER BY 1, 2;
-- 오버플로 튜플의 정확한 바이트(끝 3바이트 + 길이)
SELECT id, RIGHT(v1, 3), RIGHT(v2, 3) FROM t03 WHERE id <= 4 ORDER BY id;
-- 서브쿼리를 통한 리스트 재스캔(오버플로 페이지 재읽기)
SELECT s.id, LENGTH(s.v1) + LENGTH(s.v2) FROM (SELECT * FROM t03 ORDER BY id DESC) s WHERE s.id IN (1, 4) ORDER BY s.id;
-- UNION 으로 오버플로 + 일반 튜플 혼재
SELECT id, v1 AS v FROM t03 WHERE id = 1 UNION ALL SELECT id, k FROM t03 WHERE id = 6 ORDER BY 1;
DROP TABLE t03;
