/**
 *  This test case verifies CBRD-27963: CREATE INDEX on a table that gives the index no key to load (every key NULL,
 *  or no row) builds the empty index with xbtree_add_index (), which left common_prefix of the root leaf header as
 *  the stack had it. A multi-column index reads that field as the number of leading key columns the keys of a leaf
 *  share, so once the root leaf held two keys or more a debug server could stop on an assert, and a release server
 *  could read the keys of that leaf as compressed ones. The new root leaf now starts with common_prefix 0.
 *  What the stack left there differs from run to run, so the cases make several such indexes.
 *
 *  Coverage:
 *    Case 1: two-column index made when every key is NULL, then three keys inserted (the issue's scenario)
 *    Case 2: two-column index made on an empty table, then keys inserted
 *    Case 3: five-column index made when every key is NULL, then keys inserted and updated
 *    Case 4: unique three-column index made on an empty table, then keys inserted and deleted
 */

drop table if exists t_27963_1, t_27963_2, t_27963_3, t_27963_4;

evaluate 'Case 1: two-column index made when every key is NULL';
create table t_27963_1 (a int, b int);
insert into t_27963_1 values (null, null), (null, null), (null, null);
create index i_27963_1 on t_27963_1 (a, b);
insert into t_27963_1 values (1, null), (2, null), (3, null);
select a, b from t_27963_1 where a > 0 using index i_27963_1 order by a;

evaluate 'Case 2: two-column index made on an empty table';
create table t_27963_2 (a int, b varchar (10));
create index i_27963_2 on t_27963_2 (a, b);
insert into t_27963_2 values (1, 'x'), (1, 'y'), (2, 'x'), (3, null);
select a, b from t_27963_2 where a > 0 using index i_27963_2 order by a, b;

evaluate 'Case 3: five-column index made when every key is NULL';
create table t_27963_3 (a int, b int, c int, d int, e int);
insert into t_27963_3 values (null, null, null, null, null), (null, null, null, null, null);
create index i_27963_3 on t_27963_3 (a, b, c, d, e);
insert into t_27963_3 select 1, 1, 1, level, level from db_root connect by level <= 5;
update t_27963_3 set e = e + 10 where a = 1 and d >= 3;
select a, b, c, d, e from t_27963_3 where a = 1 using index i_27963_3 order by d;

evaluate 'Case 4: unique three-column index made on an empty table';
create table t_27963_4 (a int, b int, c int);
create unique index i_27963_4 on t_27963_4 (a, b, c);
insert into t_27963_4 select 7, 7, level from db_root connect by level <= 6;
delete from t_27963_4 where c in (2, 4);
select a, b, c from t_27963_4 where a = 7 using index i_27963_4 order by c;

drop table t_27963_1, t_27963_2, t_27963_3, t_27963_4;
