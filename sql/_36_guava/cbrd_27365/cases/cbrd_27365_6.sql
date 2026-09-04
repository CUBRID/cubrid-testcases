-- CBRD-27365 TC06: 분석 함수 정렬키(가변 문자열/NUMERIC/NULL) + group/value 리스트(backward_capable C)
-- 목적: 분석함수 정렬 레코드 미니튜플·값 리스트 역방향 스캔(qfile_scan_prev)·PERCENTILE/MEDIAN 의 늦은 도메인.
DROP TABLE IF EXISTS t06;
CREATE TABLE t06 (id INT, grp VARCHAR(10), k VARCHAR(200), n NUMERIC(10,2), d DOUBLE, i INT);
INSERT INTO t06 VALUES (1, 'g1', 'a', 1.5, 1.0, 10), (2, 'g1', REPEAT('b', 127), 2.5, 2.0, 20), (3, 'g1', REPEAT('c', 128), NULL, 3.0, NULL),
                       (4, 'g2', NULL, 4.5, NULL, 40), (5, 'g2', 'e', 5.5, 5.0, 50), (6, 'g2', '', 6.5, 6.0, 60),
                       (7, NULL, 'g', 7.5, 7.0, 70), (8, NULL, NULL, NULL, NULL, NULL), (9, 'g3', 'i', 9.5, 9.0, 90), (10, 'g3', REPEAT('j', 129), 10.5, 10.0, 100);
SELECT id, grp, LENGTH(k), ROW_NUMBER() OVER (PARTITION BY grp ORDER BY k) rn, RANK() OVER (PARTITION BY grp ORDER BY k) rk FROM t06 ORDER BY grp, rn;
SELECT id, grp, n, SUM(n) OVER (PARTITION BY grp ORDER BY n) s, AVG(d) OVER (PARTITION BY grp ORDER BY n) a FROM t06 ORDER BY grp, n, id;
SELECT id, grp, LAG(k, 1) OVER (PARTITION BY grp ORDER BY id) lg, LEAD(LENGTH(k), 1) OVER (PARTITION BY grp ORDER BY id) ld FROM t06 ORDER BY grp, id;
SELECT id, grp, FIRST_VALUE(k) OVER (PARTITION BY grp ORDER BY k) fv, LAST_VALUE(LENGTH(k)) OVER (PARTITION BY grp ORDER BY k) lv FROM t06 ORDER BY grp, id;
SELECT id, grp, NTILE(3) OVER (ORDER BY n) nt, CUME_DIST() OVER (ORDER BY n) cd, PERCENT_RANK() OVER (ORDER BY n) pr FROM t06 ORDER BY n, id;
SELECT grp, MEDIAN(n), PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY d), PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY i) FROM t06 GROUP BY grp ORDER BY grp;
SELECT id, grp, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY n) OVER (PARTITION BY grp) pc, PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY i) OVER (PARTITION BY grp) pd FROM t06 ORDER BY grp, id;
SELECT id, grp, DENSE_RANK() OVER (ORDER BY grp, k DESC) dr, NTH_VALUE(k, 2) OVER (PARTITION BY grp ORDER BY id) nv FROM t06 ORDER BY dr, id;
SELECT grp, GROUP_CONCAT(k ORDER BY k SEPARATOR '|') gc FROM t06 GROUP BY grp ORDER BY grp;
DROP TABLE t06;
