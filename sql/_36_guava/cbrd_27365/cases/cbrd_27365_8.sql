-- CBRD-27365 TC08: 늦은 도메인 확정(D-199-13) — 호스트 변수 컬럼이 NULL 로 시작한 뒤 bound 값이 오는 리스트, 재귀 CTE 공용 리스트(R1)
-- 목적: DB_TYPE_VARIABLE 컬럼이 첫 bound 값에서 확정되는 경로를 ORDER BY/GROUP BY/UNION/서브쿼리/재귀 CTE(스캔 열린 채 append) 에서 검증.
DROP TABLE IF EXISTS t08;
CREATE TABLE t08 (id INT, flag INT, v VARCHAR(20));
INSERT INTO t08 VALUES (1, 0, 'a'), (2, 0, 'b'), (3, 1, 'c'), (4, 1, 'd'), (5, 0, NULL), (6, 1, 'f');
-- (1) 호스트 변수 컬럼: 첫 행들은 NULL(flag=0 → CASE 결과 NULL), 뒤 행에서 ? 값이 들어옴. 정렬 리스트에 실림.
PREPARE s1 FROM 'SELECT id, CASE WHEN flag = 1 THEN ? ELSE NULL END AS hv FROM t08 ORDER BY id';
EXECUTE s1 USING 12345;
EXECUTE s1 USING 'text-value';
EXECUTE s1 USING 1.5;
DEALLOCATE PREPARE s1;
-- (2) 같은 컬럼을 정렬키로: NULL 이 먼저 정렬되고 확정은 bound 값에서
PREPARE s2 FROM 'SELECT id, CASE WHEN flag = 1 THEN ? ELSE NULL END AS hv FROM t08 ORDER BY hv, id';
EXECUTE s2 USING 777;
EXECUTE s2 USING 'zz';
DEALLOCATE PREPARE s2;
-- (3) GROUP BY 호스트 변수 표현식 + 집계
PREPARE s3 FROM 'SELECT CASE WHEN flag = 1 THEN ? ELSE NULL END AS hv, COUNT(*), MAX(v) FROM t08 GROUP BY hv ORDER BY hv';
EXECUTE s3 USING 42;
EXECUTE s3 USING 'grp';
DEALLOCATE PREPARE s3;
-- (4) UNION: 앞 분기 NULL only, 뒤 분기 bound
PREPARE s4 FROM 'SELECT id, CAST(NULL AS INT) + ? AS hv FROM t08 WHERE flag = 0 UNION ALL SELECT id, ? FROM t08 WHERE flag = 1 ORDER BY 1';
EXECUTE s4 USING 1, 99;
DEALLOCATE PREPARE s4;
-- (5) 서브쿼리 리스트(IN) 에 호스트 변수 컬럼
PREPARE s5 FROM 'SELECT id FROM t08 WHERE v IN (SELECT CASE WHEN flag = 1 THEN ? ELSE NULL END FROM t08) ORDER BY id';
EXECUTE s5 USING 'c';
DEALLOCATE PREPARE s5;
-- (6) 재귀 CTE 공용 리스트 최적화(R1): 비재귀부 hv=NULL(?1), 재귀부가 COALESCE(hv, ?2) 로 bound 값을 append 하면서 같은 리스트를 스캔.
--     기대: n=1..5, hv = NULL,7,7,7,7 (두 번째 실행은 문자열).
PREPARE s6 FROM 'WITH RECURSIVE c (n, hv) AS (SELECT 1, ? FROM db_root UNION ALL SELECT n + 1, COALESCE(hv, ?) FROM c WHERE n < 5) SELECT n, hv FROM c ORDER BY n';
EXECUTE s6 USING NULL, 7;
EXECUTE s6 USING NULL, 'seven';
EXECUTE s6 USING NULL, 7.25;
DEALLOCATE PREPARE s6;
-- (6b) 첫 bound 값이 2번째 반복(n=3)에서 처음 나옴: 1차 반복 뒤 qfile_unify_types(VARIABLE, tuple_cnt>0 → assert_release 후보) 를 지나
--      공용 리스트 최적화가 켜진 상태에서 스캔 열린 채 append 가 컬럼을 확정(R1 창). 기대: hv = NULL,NULL,7,7,7,7 (n=1..6).
PREPARE s6b FROM 'WITH RECURSIVE c (n, hv) AS (SELECT 1, ? FROM db_root UNION ALL SELECT n + 1, CASE WHEN n >= 2 THEN COALESCE(hv, ?) ELSE NULL END FROM c WHERE n < 6) SELECT n, hv FROM c ORDER BY n';
EXECUTE s6b USING NULL, 7;
EXECUTE s6b USING NULL, 'seven';
DEALLOCATE PREPARE s6b;
-- (7) 재귀 CTE: hv 를 재귀 조건에도 사용(스캔이 stale 레이아웃으로 값을 읽으면 조건이 깨짐)
PREPARE s7 FROM 'WITH RECURSIVE c (n, hv) AS (SELECT 1, ? FROM db_root UNION ALL SELECT n + 1, COALESCE(hv, ?) FROM c WHERE n < 6 AND (hv IS NULL OR hv < 100)) SELECT n, hv, hv IS NULL FROM c ORDER BY n';
EXECUTE s7 USING NULL, 50;
DEALLOCATE PREPARE s7;
-- (8) 비재귀부에서 이미 bound(대조군): 확정이 스캔 열기 전에 끝남
PREPARE s8 FROM 'WITH RECURSIVE c (n, hv) AS (SELECT 1, ? FROM db_root UNION ALL SELECT n + 1, hv FROM c WHERE n < 4) SELECT n, hv FROM c ORDER BY n';
EXECUTE s8 USING 3;
EXECUTE s8 USING 'abc';
DEALLOCATE PREPARE s8;
-- (9) PERCENTILE(늦은 도메인 기존 경로) 호스트 변수 인자
PREPARE s9 FROM 'SELECT flag, PERCENTILE_CONT(?) WITHIN GROUP (ORDER BY id) FROM t08 GROUP BY flag ORDER BY flag';
EXECUTE s9 USING 0.5;
DEALLOCATE PREPARE s9;
DROP TABLE t08;
