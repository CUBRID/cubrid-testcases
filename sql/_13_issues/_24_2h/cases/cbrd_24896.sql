-- This testcase verifies CBRD-24896 issue.
-- Modified to determine that index scan is impossible in the following cases "set = set {col1,col2} = {1,2}"
-- Forcing the use of an index "USING INDEX"

DROP TABLE IF EXISTS t_tbl;
CREATE TABLE t_tbl (a INT, b INT, c VARCHAR(32));
CREATE INDEX i_tbl_ab ON t_tbl (a, b);
INSERT INTO t_tbl VALUES (1, 2, 'x'), (2, 1, 'x'), (1, 1, 'x'), (3, 4, 'x');

EVALUATE 'brace set term must not be used as an index key';
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE {a, b} seteq {1, 2} USING INDEX i_tbl_ab;
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE {a, b} = {1, 2} USING INDEX i_tbl_ab;

EVALUATE 'rhs longer than lhs must not return a wrong result';
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE {a, b} = {1, 2, 3} USING INDEX i_tbl_ab;

EVALUATE 'rhs shorter than lhs must not crash';
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE {a, b} seteq {} USING INDEX i_tbl_ab;
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE {a, b} = {} USING INDEX i_tbl_ab;
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE {a, b} = {1} USING INDEX i_tbl_ab;

EVALUATE 'paren tuple term is still indexable';
SELECT /*+ recompile */ a, b, c FROM t_tbl WHERE (a, b) = (1, 2) USING INDEX i_tbl_ab;

EVALUATE 'system table without join';
SELECT /*+ recompile */ name FROM [_db_user] AS [u] WHERE {[u].[name]} seteq {'PUBLIC'} USING INDEX u__db_user_name;
SELECT /*+ recompile */ name FROM [_db_user] AS [u] WHERE {[u].[name]} = {'PUBLIC'} USING INDEX u__db_user_name;
SELECT /*+ recompile */ name FROM [_db_user] AS [u] WHERE {[u].[name]} = {'PUBLIC', 1} USING INDEX u__db_user_name;
SELECT /*+ recompile */ name FROM [_db_user] AS [u] WHERE {[u].[name]} = {} USING INDEX u__db_user_name;

DROP TABLE t_tbl;

-- create table
drop table if exists tbl;
create table tbl (col_a int, col_b int, col_c int, col_d int);
insert into tbl values(1,1,1,1),(2,2,2,2),(3,3,3,3);
create index idx on tbl(col_a,col_b,col_c);
update statistics on tbl;

EVALUATE 'index scan case';
select /*+ recompile */ * from tbl where (col_a,col_b) in ((1,1),(2,2));
select /*+ recompile */ * from tbl where (col_a,col_c) in ((1,1),(2,2));
select /*+ recompile */ * from tbl where (col_a,col_d) in ((1,1),(2,2));

EVALUATE 'sscan case';
select /*+ recompile */ * from tbl where {col_a,col_b} in ((1,1),(2,2));
select /*+ recompile */ * from tbl where {col_a} = {2};
select /*+ recompile */ * from tbl where {col_a} = {};

drop table tbl;
