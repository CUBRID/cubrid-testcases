/**
 *  This test case verifies CBRD-27583: four places where a bind or a NULL operand met a
 *  decision the compiler makes once, found by a review fuzzer on PR 8213.
 *
 *  Case 1: c4 = vc and c4 = ? on a CHAR(4) and a VARCHAR column.  The optimizer copies the
 *  bind into vc = ?, and the client no longer casts the bind to CHAR(4), so the row
 *  ('a   ', 'a') matched although c4 = vc is false.  An equality of a CHAR column with a
 *  bind is no longer copied, and no row matches in every join method.
 *  Case 2: rank () over (partition by mod (v, null)) failed with -181 on v = 'a' because the
 *  string operand was planned a DOUBLE conversion though the NULL operand makes the result
 *  NULL.  The partition key is NULL for every row.
 *  Case 3: for orderby_num () <= ? with a NULL bind failed with -454 on the index key limit.
 *  A NULL bound matches no row, as a NULL literal does.
 *  Case 4: a.i = nvl (?, b.i) under a nested loop join with a DOUBLE bind keyed the memo by
 *  the converted domain while the slot held the INTEGER value (a debug build asserted).
 *  Case 5: a statement prepared without its values, as a JDBC client prepares.  A cast
 *  that a first fix of Case 1 put on the copy of n = ? typed the bind's position as
 *  NUMERIC (38,0), so the DOUBLE bind of n = ? itself lost its value, and the INTEGER bind
 *  of c1 = ? failed with 'Cannot coerce host var' on a CHAR (1) column.
 *  Case 6: a fixed BIT bind as a result column, a 1-byte value before a 3-byte one in one
 *  statement: the plan of the first value's BIT (8) cut the second to its first byte.
 *  Case 7: a hash or merge join key under arithmetic with a NULL bind (a.x = b.x + ?): the key
 *  side typed NULL left the join undecided and the plan was refused with -1383.
 *
 *  Judged by the rows: Case 1 answers no row, Case 2 three rows of rank 1, 2, 3, Case 3 no row
 *  for the NULL bind, Case 4 the counts of the literal statements beside them, and Case 5 the
 *  row 119673559571800002 for the DOUBLE bind, no row for 35203 and the row 'Y' for 'Y', and
 *  Case 6 each bound value whole, and Case 7 0 for the NULL bind and 2 for 0.
 */

drop table if exists t_ca, t_cb, t_md, t_key, t_o, t_i, t_pn, t_jx;


evaluate 'Case 1: c4 = vc and c4 = ? on CHAR(4) and VARCHAR columns';
create table t_ca (id int, c4 char(4), vc varchar(6));
insert into t_ca values (1, 'a   ', 'a'), (2, 'abc ', 'abc');
create table t_cb (id int, vc varchar(6));
insert into t_cb values (2, 'abc');
$varchar,$a;
select id from t_ca where c4 = vc and c4 = ? order by 1;
select id from t_ca where c4 = vc and c4 = 'a' order by 1;
$varchar,$abc;
select /*+ use_nl */ a.id from t_ca a, t_cb b where a.c4 = b.vc and a.c4 = ? order by 1;
$varchar,$abc;
select /*+ use_hash */ a.id from t_ca a, t_cb b where a.c4 = b.vc and a.c4 = ? order by 1;
$varchar,$abc;
select /*+ use_merge */ a.id from t_ca a, t_cb b where a.c4 = b.vc and a.c4 = ? order by 1;


evaluate 'Case 2: an analytic partition key over MOD and ROUND with a NULL operand';
create table t_md (id int, v varchar(10));
insert into t_md values (1, '1'), (2, 'a'), (3, null);
select id, rank () over (partition by mod (v, null) order by id) from t_md order by id;
select id, rank () over (partition by round (v, null) order by id) from t_md order by id;


evaluate 'Case 3: an index key limit bound to NULL';
create table t_key (id int primary key);
insert into t_key values (1), (2), (3);
$int,$NULL;
select id from t_key order by id for orderby_num () <= ?;
select id from t_key order by id for orderby_num () <= null;
$int,$2;
select id from t_key order by id for orderby_num () <= ?;


evaluate 'Case 4: a memoized nested loop key over NVL with a wider bind';
create table t_o (i int);
create table t_i (i int);
insert into t_o select mod (rownum, 10) from db_class a, db_class b limit 2000;
insert into t_i select mod (rownum, 10) from db_class a, db_class b limit 2000;
create index i_t_o on t_o (i);
update statistics on t_o, t_i;
$double,$1.0;
select /*+ use_nl */ count (*) from t_o a, t_i b where a.i = nvl (?, b.i);
select /*+ use_nl */ count (*) from t_o a, t_i b where a.i = nvl (1.0, b.i);
$double,$0.0;
select /*+ use_nl */ count (*) from t_o a, t_i b where a.i = b.i - ?;


evaluate 'Case 5: binds prepared without their values beside a copy of the equality';
create table t_pn (n numeric(38,0), c1 char(1));
insert into t_pn values (119673559571800002, 'N'), (1, 'Y');
prepare s_num from 'select n from t_pn where n = ? and n >= 0';
execute s_num using 1.19673559571800002e17;
prepare s_char from 'select c1 from t_pn where c1 = ?';
execute s_char using 35203;
execute s_char using 'Y';


evaluate 'Case 6: a fixed BIT bind as a result column, short then long';
$bit,$AB;
select ? from db_root;
$bit,$ABCDEF;
select ? from db_root;
$bit,$01234567;
select bit_length (?) from db_root;


evaluate 'Case 7: a hash and a merge join key under arithmetic with a NULL bind';
create table t_jx (x int, y numeric(10,2));
insert into t_jx values (1, 1.5), (2, 2.5);
prepare s_hash from 'select /*+ use_hash */ count (*) from t_jx a, t_jx b where a.x = b.x + ?';
execute s_hash using null;
execute s_hash using 0;
prepare s_merge from 'select /*+ use_merge */ count (*) from t_jx a, t_jx b where a.x = b.x + ?';
execute s_merge using null;
prepare s_num from 'select /*+ use_hash */ count (*) from t_jx a, t_jx b where a.y = b.y * ?';
execute s_num using null;
prepare s_derived from 'select /*+ use_hash */ count (*) from t_jx a, (select x + ? as v from t_jx) b where a.x = b.v';
execute s_derived using null;

drop table t_ca, t_cb, t_md, t_key, t_o, t_i, t_pn, t_jx;
