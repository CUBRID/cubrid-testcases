-- Test to address the following issues when performing ANN queries using a session variable:
--   Problem where the index is not selected
--   Segfault occurs if the session variable is not initialized

DROP TABLE tbl_sv;
CREATE TABLE tbl_sv (id int, vec vector(3)) DONT_REUSE_OID;
CREATE VECTOR INDEX idx_v ON tbl_sv(vec EUCLIDEAN);
INSERT INTO tbl_sv VALUES (1, '[1,2,3]');
INSERT INTO tbl_sv VALUES (2, '[1,0,2]');
INSERT INTO tbl_sv VALUES (3, '[3,4,5]');
INSERT INTO tbl_sv VALUES (4, '[0,0,1]');
INSERT INTO tbl_sv VALUES (5, '[5,6,7]');
INSERT INTO tbl_sv VALUES (6, '[9,8,7]');
INSERT INTO tbl_sv VALUES (7, '[1,1,0]');
INSERT INTO tbl_sv VALUES (8, '[0,1,0]');
INSERT INTO tbl_sv VALUES (9, '[1,1,1]');
INSERT INTO tbl_sv VALUES (10, '[1,0,1]');
INSERT INTO tbl_sv VALUES (11, '[2,3,4]');
INSERT INTO tbl_sv VALUES (12, '[1,1,1]');

-- Test 1: session variable is not initialized
select /*+ recompile no_parallel_heap_scan */ id from tbl_sv order by vec <c> @a limit 5;

-- Test 2: session variable is initialized
set @a = (select vec from tbl_sv limit 1);
select /*+ recompile no_parallel_heap_scan */ id from tbl_sv order by vec <c> @a limit 5;

DROP TABLE tbl_sv;
