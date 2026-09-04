-- CBRD-27365 TC07: SET/MULTISET/SEQUENCE/JSON 컬럼(index_readval 없는 SCRATCH 타입)의 리스트 파일 경로
-- 목적: 접근자 스크래치 복사(D-182 SCRATCH)·정렬 비교자 스택/힙 폴백(>256B SET 키)·NULL 컬렉션.
DROP TABLE IF EXISTS t07;
CREATE TABLE t07 (id INT, s SET(INT), m MULTISET(VARCHAR(50)), q SEQUENCE(INT), j JSON, tag VARCHAR(5));
INSERT INTO t07 VALUES (1, {1, 2, 3}, {'a', 'a', 'b'}, {3, 1, 2}, '{"k": 1, "v": [1, 2]}', 'x');
INSERT INTO t07 VALUES (2, {}, {}, {}, '[]', 'y');
INSERT INTO t07 VALUES (3, NULL, NULL, NULL, NULL, NULL);
INSERT INTO t07 VALUES (4, {5, 4}, {'zzzz'}, {9}, '"str"', 'z');
INSERT INTO t07 VALUES (5, {1, 2, 3}, {'a', 'b', 'a'}, {3, 1, 2}, '{"k": 1, "v": [1, 2]}', 'x');
INSERT INTO t07 VALUES (6, {1}, {'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww', 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww', 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, '{"big": "' || REPEAT('B', 300) || '"}', 'w');
-- 컬렉션 값 통과(정렬·DISTINCT·그룹)
SELECT id, s, m, q FROM t07 ORDER BY id DESC;
SELECT id, s FROM t07 ORDER BY s, id;
SELECT id, SET_SIZE(m), q FROM t07 ORDER BY s DESC, id;
SELECT DISTINCT s, tag FROM t07 ORDER BY 2, 1;
SELECT tag, COUNT(*), MAX(id) FROM t07 GROUP BY tag ORDER BY tag;
-- >256B 컬렉션 키 정렬(비교자 힙 폴백)
SELECT id, SET_SIZE(q), SET_SIZE(m) FROM t07 ORDER BY m DESC, id;
-- JSON 값 통과 + 정렬키
SELECT id, j, JSON_TYPE(j) FROM t07 ORDER BY id;
SELECT id, JSON_EXTRACT(j, '$.k') FROM t07 WHERE j IS NOT NULL ORDER BY JSON_EXTRACT(j, '$.k'), id;
SELECT id, LENGTH(JSON_EXTRACT(j, '$.big')) FROM t07 WHERE id = 6;
-- 컬렉션 집계와 UNION
SELECT s FROM t07 WHERE id <= 2 UNION SELECT s FROM t07 WHERE id >= 4 ORDER BY 1;
SELECT id FROM t07 WHERE s IN (SELECT s FROM t07 WHERE id = 5) ORDER BY id;
DROP TABLE t07;
