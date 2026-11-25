/**
 *  This test case verifies CBRD-27709: Skip the unique-key re-lookup for a duplicate older than the lookup
 *
 *  INSERT ... ON DUPLICATE KEY UPDATE (ODKU) and REPLACE settle on the last version of a duplicate row
 *  and then ask the unique key again. With the change, a release build skips that second lookup when the
 *  settled version was committed before the snapshot of the first lookup, and a debug build still asks
 *  the key and asserts that it names the same row. The results do not change. So Cases 1 to 10 and 12
 *  to 15 each run the same statements on a table whose rows an earlier transaction committed, where a
 *  release build skips the second lookup and a debug build asserts its result, and on a twin table whose
 *  rows the same transaction inserted, where the settled version is the own version of the transaction
 *  and the key is asked again in every build. The rows of the two tables must match. Case 11 rolls back
 *  the same statements to show that the twin rows are not committed when they run. In Cases 3 and 13
 *  the second row of each statement settles on the version that its first row made, an own version,
 *  so that row is looked up again in both tables.
 *
 *  Each case prints the isolation level of its transaction with select :lvl, where 4 is READ COMMITTED,
 *  5 is REPEATABLE READ and 6 is SERIALIZABLE.
 *
 *  Coverage:
 *    Case 1:  ODKU and REPLACE of one row at READ COMMITTED
 *    Case 2:  INSERT SELECT with ODKU and REPLACE SELECT over 10 duplicate rows
 *    Case 3:  one statement with the same key twice
 *    Case 4:  two unique indexes, and NULL in a unique column
 *    Case 5:  an ODKU whose update collides on the second unique index fails and changes no row
 *    Case 6:  a multi-column unique key with a DESC column
 *    Case 7:  a hash-partitioned table
 *    Case 8:  a primary key with a case-insensitive collation
 *    Case 9:  a key moved and rolled back to a savepoint in the same transaction
 *    Case 10: duplicates stored as overflow records
 *    Case 11: the twin rows are not committed when the twin statements run, as a rollback shows
 *    Case 12: Case 1 at REPEATABLE READ
 *    Case 13: Case 3 at REPEATABLE READ
 *    Case 14: Case 9 at REPEATABLE READ
 *    Case 15: Case 1 at SERIALIZABLE
 */

drop table if exists t27709_g, t27709_g_own, t27709_src, t27709_m, t27709_m_own, t27709_r, t27709_r_own, t27709_k;
drop table if exists t27709_k_own, t27709_u, t27709_u_own, t27709_x, t27709_x_own, t27709_d, t27709_d_own, t27709_p;
drop table if exists t27709_p_own, t27709_c, t27709_c_own, t27709_s, t27709_s_own, t27709_o, t27709_o_own, t27709_e;
drop table if exists t27709_e_own, t27709_seed;

evaluate 'Case 1: ODKU and REPLACE of one row at READ COMMITTED; result = the same rows in both tables';
set transaction isolation level read committed;
drop table if exists t27709_g;
create table t27709_g (id int primary key, v int);
drop table if exists t27709_g_own;
create table t27709_g_own (id int primary key, v int);
insert into t27709_g values (1, 10), (2, 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_g values (1, 100) on duplicate key update v = v + 1;
replace into t27709_g values (2, 200);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_g_own values (1, 10), (2, 20);
insert into t27709_g_own values (1, 100) on duplicate key update v = v + 1;
replace into t27709_g_own values (2, 200);
select id, v from t27709_g order by id;
select id, v from t27709_g_own order by id;
commit;
select id, v from t27709_g order by id;
select id, v from t27709_g_own order by id;
autocommit on;

evaluate 'Case 2: INSERT SELECT with ODKU and REPLACE SELECT over 10 duplicate rows; result = the same rows in both tables';
set transaction isolation level read committed;
create table t27709_src (id int primary key, v int);
insert into t27709_src select rownum, 0 from db_class a, db_class b limit 10;
create table t27709_m (id int primary key, v int);
create table t27709_r (id int primary key, v int);
create table t27709_m_own (id int primary key, v int);
create table t27709_r_own (id int primary key, v int);
insert into t27709_m select id, id * 10 from t27709_src;
insert into t27709_r select id, id * 10 from t27709_src;
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_m select id, v from t27709_src on duplicate key update v = v + 1;
replace into t27709_r select id, id + 1000 from t27709_src;
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_m_own select id, id * 10 from t27709_src;
insert into t27709_r_own select id, id * 10 from t27709_src;
insert into t27709_m_own select id, v from t27709_src on duplicate key update v = v + 1;
replace into t27709_r_own select id, id + 1000 from t27709_src;
select id, v from t27709_m order by id;
select id, v from t27709_m_own order by id;
select id, v from t27709_r order by id;
select id, v from t27709_r_own order by id;
commit;
select id, v from t27709_m order by id;
select id, v from t27709_m_own order by id;
select id, v from t27709_r order by id;
select id, v from t27709_r_own order by id;
autocommit on;

evaluate 'Case 3: one statement with the same key twice; result = the same rows in both tables';
set transaction isolation level read committed;
drop table if exists t27709_k;
create table t27709_k (id int primary key, v int);
drop table if exists t27709_k_own;
create table t27709_k_own (id int primary key, v int);
insert into t27709_k values (1, 10), (3, 30);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
-- the second row of each statement settles on the version that its first row made
insert into t27709_k values (1, 100), (1, 200) on duplicate key update v = v + 1;
insert into t27709_k values (2, 100), (2, 200) on duplicate key update v = v + 1;
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_k_own values (1, 10), (3, 30);
-- the second row of each statement settles on the version that its first row made
insert into t27709_k_own values (1, 100), (1, 200) on duplicate key update v = v + 1;
insert into t27709_k_own values (2, 100), (2, 200) on duplicate key update v = v + 1;
select id, v from t27709_k order by id;
select id, v from t27709_k_own order by id;
commit;
select id, v from t27709_k order by id;
select id, v from t27709_k_own order by id;
autocommit on;

evaluate 'Case 4: two unique indexes, and NULL in a unique column; result = the same rows in both tables';
set transaction isolation level read committed;
create table t27709_u (id int primary key, u int unique, v int);
create table t27709_u_own (id int primary key, u int unique, v int);
insert into t27709_u values (1, 10, 0), (2, 20, 0), (3, 30, 0), (4, null, 0);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
-- (1, 20) duplicates row 1 on id and row 2 on u, so REPLACE deletes both
replace into t27709_u values (1, 20, 9);
insert into t27709_u values (3, 99, 9) on duplicate key update v = v + 1;
-- a NULL in u duplicates no row
insert into t27709_u values (5, null, 7) on duplicate key update v = v + 1;
replace into t27709_u values (4, null, 8);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_u_own values (1, 10, 0), (2, 20, 0), (3, 30, 0), (4, null, 0);
-- (1, 20) duplicates row 1 on id and row 2 on u, so REPLACE deletes both
replace into t27709_u_own values (1, 20, 9);
insert into t27709_u_own values (3, 99, 9) on duplicate key update v = v + 1;
-- a NULL in u duplicates no row
insert into t27709_u_own values (5, null, 7) on duplicate key update v = v + 1;
replace into t27709_u_own values (4, null, 8);
select id, u, v from t27709_u order by id;
select id, u, v from t27709_u_own order by id;
commit;
select id, u, v from t27709_u order by id;
select id, u, v from t27709_u_own order by id;
autocommit on;

evaluate 'Case 5: an ODKU whose update collides on the second unique index fails with an error and changes no row';
set transaction isolation level read committed;
create table t27709_x (id int primary key, u int unique, v int);
create table t27709_x_own (id int primary key, u int unique, v int);
insert into t27709_x values (1, 10, 0), (2, 20, 0);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
-- the duplicate is row 2, and setting its u to 10 collides with row 1
insert into t27709_x values (2, 50, 9) on duplicate key update u = 10;
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_x_own values (1, 10, 0), (2, 20, 0);
-- the duplicate is row 2, and setting its u to 10 collides with row 1
insert into t27709_x_own values (2, 50, 9) on duplicate key update u = 10;
select id, u, v from t27709_x order by id;
select id, u, v from t27709_x_own order by id;
commit;
select id, u, v from t27709_x order by id;
select id, u, v from t27709_x_own order by id;
autocommit on;

evaluate 'Case 6: a multi-column unique key with a DESC column; result = the same rows in both tables';
set transaction isolation level read committed;
create table t27709_d (a int, b varchar(10), v int);
create unique index u_d_ab on t27709_d (a desc, b);
create table t27709_d_own (a int, b varchar(10), v int);
create unique index u_d_own_ab on t27709_d_own (a desc, b);
insert into t27709_d values (1, 'x', 10), (1, 'y', 30), (2, 'y', 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_d values (1, 'x', 0) on duplicate key update v = v + 1;
replace into t27709_d values (2, 'y', 99);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_d_own values (1, 'x', 10), (1, 'y', 30), (2, 'y', 20);
insert into t27709_d_own values (1, 'x', 0) on duplicate key update v = v + 1;
replace into t27709_d_own values (2, 'y', 99);
select a, b, v from t27709_d order by a, b;
select a, b, v from t27709_d_own order by a, b;
commit;
select a, b, v from t27709_d order by a, b;
select a, b, v from t27709_d_own order by a, b;
autocommit on;

evaluate 'Case 7: a hash-partitioned table; result = the same rows in both tables';
set transaction isolation level read committed;
create table t27709_p (id int primary key, v int) partition by hash (id) partitions 4;
create table t27709_p_own (id int primary key, v int) partition by hash (id) partitions 4;
insert into t27709_p values (1, 10), (2, 20), (3, 30);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_p values (2, 0) on duplicate key update v = v + 1;
replace into t27709_p values (3, 99);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_p_own values (1, 10), (2, 20), (3, 30);
insert into t27709_p_own values (2, 0) on duplicate key update v = v + 1;
replace into t27709_p_own values (3, 99);
select id, v from t27709_p order by id;
select id, v from t27709_p_own order by id;
commit;
select id, v from t27709_p order by id;
select id, v from t27709_p_own order by id;
autocommit on;

evaluate 'Case 8: a primary key with a case-insensitive collation; result = the same rows in both tables';
set transaction isolation level read committed;
create table t27709_c (s varchar(10) collate utf8_en_ci primary key, v int);
create table t27709_c_own (s varchar(10) collate utf8_en_ci primary key, v int);
insert into t27709_c values ('abc', 1), ('def', 2);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
-- utf8_en_ci makes 'ABC' a duplicate of 'abc' and 'DEF' a duplicate of 'def'
insert into t27709_c values ('ABC', 9) on duplicate key update v = v + 1;
replace into t27709_c values ('DEF', 9);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_c_own values ('abc', 1), ('def', 2);
-- utf8_en_ci makes 'ABC' a duplicate of 'abc' and 'DEF' a duplicate of 'def'
insert into t27709_c_own values ('ABC', 9) on duplicate key update v = v + 1;
replace into t27709_c_own values ('DEF', 9);
select s, v from t27709_c order by s;
select s, v from t27709_c_own order by s;
commit;
select s, v from t27709_c order by s;
select s, v from t27709_c_own order by s;
autocommit on;

evaluate 'Case 9: a key moved and rolled back to a savepoint in the same transaction; result = the same rows in both tables';
set transaction isolation level read committed;
drop table if exists t27709_s;
create table t27709_s (id int primary key, v int);
drop table if exists t27709_s_own;
create table t27709_s_own (id int primary key, v int);
insert into t27709_s values (1, 10), (2, 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
savepoint sp1;
update t27709_s set id = 5 where id = 1;
-- the rollback brings back the version of row 1 that the transaction had before the savepoint
rollback to savepoint sp1;
insert into t27709_s values (1, 100) on duplicate key update v = v + 1;
replace into t27709_s values (2, 200);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_s_own values (1, 10), (2, 20);
savepoint sp1;
update t27709_s_own set id = 5 where id = 1;
-- the rollback brings back the version of row 1 that the transaction had before the savepoint
rollback to savepoint sp1;
insert into t27709_s_own values (1, 100) on duplicate key update v = v + 1;
replace into t27709_s_own values (2, 200);
select id, v from t27709_s order by id;
select id, v from t27709_s_own order by id;
commit;
select id, v from t27709_s order by id;
select id, v from t27709_s_own order by id;
autocommit on;

evaluate 'Case 10: duplicates stored as overflow records; result = the same rows in both tables';
set transaction isolation level read committed;
create table t27709_seed (id int primary key);
insert into t27709_seed select rownum from db_class a, db_class b limit 320;
-- group_concat returns at most group_concat_max_len bytes, which is 1024 by default
set system parameters 'group_concat_max_len=65536';
-- 2 rows per table, each 320 SHA-512 strings of 128 hex digits joined into 40960 bytes: about 3 overflow pages per row, past the largest record that one 16 KB page of the CTP database holds, so that each row is stored as an overflow record
-- hex digits leave the string compression little to remove, unlike a repeated character; disk_size shows the stored size
create table t27709_o (id int primary key, pad varchar(65536), v int);
create table t27709_o_own (id int primary key, pad varchar(65536), v int);
insert into t27709_o select 1, group_concat(sha2(id, 512) order by 1 separator ''), 10 from t27709_seed;
insert into t27709_o select 2, group_concat(sha2(id + 1000, 512) order by 1 separator ''), 20 from t27709_seed;
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_o values (1, 'x', 100) on duplicate key update v = v + 1;
replace into t27709_o values (2, 'y', 200);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_o_own select 1, group_concat(sha2(id, 512) order by 1 separator ''), 10 from t27709_seed;
insert into t27709_o_own select 2, group_concat(sha2(id + 1000, 512) order by 1 separator ''), 20 from t27709_seed;
insert into t27709_o_own values (1, 'x', 100) on duplicate key update v = v + 1;
replace into t27709_o_own values (2, 'y', 200);
select id, length(pad), disk_size(pad), v from t27709_o order by id;
select id, length(pad), disk_size(pad), v from t27709_o_own order by id;
commit;
select id, length(pad), disk_size(pad), v from t27709_o order by id;
select id, length(pad), disk_size(pad), v from t27709_o_own order by id;
autocommit on;
set system parameters 'group_concat_max_len=default';

evaluate 'Case 11: the twin rows are not committed when the twin statements run; result = the same rows in both tables before the rollback, committed rows in the base table and no rows in the twin table after it';
set transaction isolation level read committed;
create table t27709_e (id int primary key, v int);
create table t27709_e_own (id int primary key, v int);
insert into t27709_e values (1, 10), (2, 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_e values (1, 100) on duplicate key update v = v + 1;
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_e_own values (1, 10), (2, 20);
insert into t27709_e_own values (1, 100) on duplicate key update v = v + 1;
select id, v from t27709_e order by id;
select id, v from t27709_e_own order by id;
rollback;
select id, v from t27709_e order by id;
select id, v from t27709_e_own order by id;
autocommit on;

evaluate 'Case 12: Case 1 at REPEATABLE READ; result = the same rows in both tables';
set transaction isolation level repeatable read;
drop table if exists t27709_g;
create table t27709_g (id int primary key, v int);
drop table if exists t27709_g_own;
create table t27709_g_own (id int primary key, v int);
insert into t27709_g values (1, 10), (2, 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_g values (1, 100) on duplicate key update v = v + 1;
replace into t27709_g values (2, 200);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_g_own values (1, 10), (2, 20);
insert into t27709_g_own values (1, 100) on duplicate key update v = v + 1;
replace into t27709_g_own values (2, 200);
select id, v from t27709_g order by id;
select id, v from t27709_g_own order by id;
commit;
select id, v from t27709_g order by id;
select id, v from t27709_g_own order by id;
autocommit on;

evaluate 'Case 13: Case 3 at REPEATABLE READ; result = the same rows in both tables';
set transaction isolation level repeatable read;
drop table if exists t27709_k;
create table t27709_k (id int primary key, v int);
drop table if exists t27709_k_own;
create table t27709_k_own (id int primary key, v int);
insert into t27709_k values (1, 10), (3, 30);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
-- the second row of each statement settles on the version that its first row made
insert into t27709_k values (1, 100), (1, 200) on duplicate key update v = v + 1;
insert into t27709_k values (2, 100), (2, 200) on duplicate key update v = v + 1;
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_k_own values (1, 10), (3, 30);
-- the second row of each statement settles on the version that its first row made
insert into t27709_k_own values (1, 100), (1, 200) on duplicate key update v = v + 1;
insert into t27709_k_own values (2, 100), (2, 200) on duplicate key update v = v + 1;
select id, v from t27709_k order by id;
select id, v from t27709_k_own order by id;
commit;
select id, v from t27709_k order by id;
select id, v from t27709_k_own order by id;
autocommit on;

evaluate 'Case 14: Case 9 at REPEATABLE READ; result = the same rows in both tables';
set transaction isolation level repeatable read;
drop table if exists t27709_s;
create table t27709_s (id int primary key, v int);
drop table if exists t27709_s_own;
create table t27709_s_own (id int primary key, v int);
insert into t27709_s values (1, 10), (2, 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
savepoint sp1;
update t27709_s set id = 5 where id = 1;
-- the rollback brings back the version of row 1 that the transaction had before the savepoint
rollback to savepoint sp1;
insert into t27709_s values (1, 100) on duplicate key update v = v + 1;
replace into t27709_s values (2, 200);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_s_own values (1, 10), (2, 20);
savepoint sp1;
update t27709_s_own set id = 5 where id = 1;
-- the rollback brings back the version of row 1 that the transaction had before the savepoint
rollback to savepoint sp1;
insert into t27709_s_own values (1, 100) on duplicate key update v = v + 1;
replace into t27709_s_own values (2, 200);
select id, v from t27709_s order by id;
select id, v from t27709_s_own order by id;
commit;
select id, v from t27709_s order by id;
select id, v from t27709_s_own order by id;
autocommit on;

evaluate 'Case 15: Case 1 at SERIALIZABLE; result = the same rows in both tables';
set transaction isolation level serializable;
drop table if exists t27709_g;
create table t27709_g (id int primary key, v int);
drop table if exists t27709_g_own;
create table t27709_g_own (id int primary key, v int);
insert into t27709_g values (1, 10), (2, 20);
autocommit off;
get transaction isolation level into :lvl;
select :lvl;
insert into t27709_g values (1, 100) on duplicate key update v = v + 1;
replace into t27709_g values (2, 200);
-- twin: the rows are inserted in this transaction, so the duplicates are its own versions
insert into t27709_g_own values (1, 10), (2, 20);
insert into t27709_g_own values (1, 100) on duplicate key update v = v + 1;
replace into t27709_g_own values (2, 200);
select id, v from t27709_g order by id;
select id, v from t27709_g_own order by id;
commit;
select id, v from t27709_g order by id;
select id, v from t27709_g_own order by id;
autocommit on;

-- READ COMMITTED is the default isolation level of the server
set transaction isolation level read committed;
drop table t27709_g, t27709_g_own, t27709_src, t27709_m, t27709_m_own, t27709_r, t27709_r_own, t27709_k;
drop table t27709_k_own, t27709_u, t27709_u_own, t27709_x, t27709_x_own, t27709_d, t27709_d_own, t27709_p;
drop table t27709_p_own, t27709_c, t27709_c_own, t27709_s, t27709_s_own, t27709_o, t27709_o_own, t27709_e;
drop table t27709_e_own, t27709_seed;
drop variable lvl;
