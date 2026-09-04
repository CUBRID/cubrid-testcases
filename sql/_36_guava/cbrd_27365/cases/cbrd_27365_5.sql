-- CBRD-27365 TC05: 해시 조인 키(INT/VARCHAR/NUMERIC/혼합 NULL) + 파티션(오버플로) 경로
-- 목적: 해시조인 빌드 리스트에 해시키를 in-place 기록하는 hjoin_update_tuple_hash_key·파티션 리스트 raw 튜플 복사·외부 조인 NULL 확장.
DROP TABLE IF EXISTS t05a, t05b;
CREATE TABLE t05a (id INT, ki INT, kv VARCHAR(50), kn NUMERIC(15,2), pad VARCHAR(200));
CREATE TABLE t05b (id INT, ki INT, kv VARCHAR(50), kn NUMERIC(15,2), pad VARCHAR(200));
INSERT INTO t05a SELECT ROWNUM, MOD(ROWNUM, 97), CONCAT('k', MOD(ROWNUM, 89)), MOD(ROWNUM, 83) / 4.0, REPEAT('a', MOD(ROWNUM, 150)) FROM db_class a, db_class b LIMIT 3000;
INSERT INTO t05b SELECT ROWNUM, MOD(ROWNUM * 7, 97), CONCAT('k', MOD(ROWNUM * 3, 89)), MOD(ROWNUM * 5, 83) / 4.0, REPEAT('b', MOD(ROWNUM, 140)) FROM db_class a, db_class b LIMIT 3000;
INSERT INTO t05a VALUES (100001, NULL, NULL, NULL, NULL), (100002, NULL, 'k1', NULL, ''), (100003, 1, NULL, 0.25, NULL);
INSERT INTO t05b VALUES (200001, NULL, NULL, NULL, NULL), (200002, NULL, 'k1', NULL, ''), (200003, 1, NULL, 0.25, NULL);
UPDATE STATISTICS ON t05a, t05b;
-- 고정 키
SELECT COUNT(*), SUM(a.id + b.id) FROM t05a a, t05b b WHERE a.ki = b.ki;
-- 가변 키
SELECT COUNT(*), SUM(a.id) FROM t05a a, t05b b WHERE a.kv = b.kv;
-- NUMERIC(가변 취급) 키
SELECT COUNT(*), MIN(a.kn), MAX(b.kn) FROM t05a a, t05b b WHERE a.kn = b.kn;
-- 복합 키(고정+가변)
SELECT COUNT(*) FROM t05a a, t05b b WHERE a.ki = b.ki AND a.kv = b.kv;
-- 외부 조인: NULL 키 확장 행
SELECT a.id, b.id FROM t05a a LEFT OUTER JOIN t05b b ON a.kv = b.kv WHERE a.id > 100000 ORDER BY a.id, b.id;
SELECT a.id, b.id FROM t05a a RIGHT OUTER JOIN t05b b ON a.ki = b.ki WHERE b.id > 200000 ORDER BY b.id, a.id;
-- 조인 결과 정렬 + 가변 pad 동반
SELECT a.id, b.id, LENGTH(a.pad), LENGTH(b.pad) FROM t05a a, t05b b WHERE a.ki = b.ki AND a.id < 30 AND b.id < 30 ORDER BY a.id, b.id;
-- 조인 결과 그룹
SELECT a.kv, COUNT(*) FROM t05a a, t05b b WHERE a.kv = b.kv GROUP BY a.kv ORDER BY COUNT(*) DESC, a.kv LIMIT 10;
DROP TABLE t05a, t05b;
