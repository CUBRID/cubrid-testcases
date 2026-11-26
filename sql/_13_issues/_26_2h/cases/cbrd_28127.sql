/**
 *  This test case verifies CBRD-28127: information_schema.tables.auto_increment
 *  and db_serial.current_val read the serial cache
 *
 *  A serial with a cache records in _db_serial.current_val the end of the block
 *  it reserved. The two views read that column, so auto_increment showed the
 *  block end plus the increment instead of the id the next INSERT gets, and
 *  current_val showed the block end instead of the last value NEXT_VALUE gave.
 *  The views now read the value from the serial cache through the internal
 *  function serial_current_value_by_oid.
 *
 *  Coverage:
 *    Case 1:  after 5 rows, auto_increment equals the id the next INSERT gets
 *    Case 2:  inside a transaction that inserted a row and after its rollback,
 *             auto_increment equals the id the next INSERT gets
 *    Case 3:  a table that has had no INSERT shows its start value
 *    Case 4:  a table without an AUTO_INCREMENT column shows NULL
 *    Case 5:  next to the INT maximum, auto_increment shows the next id up to
 *             the maximum and NULL past it
 *    Case 6:  with a negative increment, auto_increment shows the next id down
 *             to the minimum and NULL past it
 *    Case 7:  current_val of a cached serial is the last value NEXT_VALUE gave
 *    Case 8:  current_val of a serial that has given no value is its start value
 *    Case 9:  in a correlated subquery, serial_current_value_by_oid gives the
 *             value NEXT_VALUE gave in the same row
 *    Case 10: serial_current_value_by_oid takes only a _db_serial alias
 *    Case 11: for a user outside the DBA group, auto_increment is the id the
 *             next INSERT gets and current_val the last value NEXT_VALUE gave
 *    Case 12: a condition on current_val is checked outside the unmerged
 *             db_serial view
 *    Case 13: past the BIGINT range, current_val of a cached serial is the last
 *             value NEXT_VALUE gave, going up and going down
 */

-- AUTO_INCREMENT values come from the serial cache: auto_increment_cache_size is left at its default 20
drop table if exists t28127_ai, t28127_ai_start, t28127_no_ai, t28127_ai_max, t28127_ai_down, t28127_rows, t28127_oid;
drop serial if exists s28127_cached;
drop serial if exists s28127_unused;
drop serial if exists s28127_rows;
drop serial if exists s28127_above_bigint;
drop serial if exists s28127_below_bigint;

evaluate 'Case 1: after 5 rows, auto_increment equals the id the next INSERT gets; result = 6, 6';
create table t28127_ai (id int auto_increment primary key, v int);
insert into t28127_ai (v) values (1), (2), (3), (4), (5);
select auto_increment from information_schema.tables where table_name = 't28127_ai';
insert into t28127_ai (v) values (6);
select max (id) from t28127_ai;

evaluate 'Case 2: inside a transaction that inserted a row and after its rollback, auto_increment equals the id the next INSERT gets; result = 8, 8, 8';
-- t28127_ai holds the ids 1 to 6 from Case 1
autocommit off;
-- the id that a rolled back INSERT took is not given again
insert into t28127_ai (v) values (7);
select auto_increment from information_schema.tables where table_name = 't28127_ai';
rollback;
autocommit on;
select auto_increment from information_schema.tables where table_name = 't28127_ai';
insert into t28127_ai (v) values (8);
select max (id) from t28127_ai;

evaluate 'Case 3: a table that has had no INSERT shows its start value; result = 100';
create table t28127_ai_start (id int auto_increment (100, 1), v int);
select auto_increment from information_schema.tables where table_name = 't28127_ai_start';

evaluate 'Case 4: a table without an AUTO_INCREMENT column shows NULL; result = NULL';
create table t28127_no_ai (v int);
select auto_increment from information_schema.tables where table_name = 't28127_no_ai';

evaluate 'Case 5: next to the INT maximum, auto_increment shows the next id up to the maximum and NULL past it; result = 2147483646, 2147483647, NULL';
create table t28127_ai_max (id int auto_increment (2147483646, 1), v int);
select auto_increment from information_schema.tables where table_name = 't28127_ai_max';
insert into t28127_ai_max (v) values (1);
select auto_increment from information_schema.tables where table_name = 't28127_ai_max';
insert into t28127_ai_max (v) values (2);
select auto_increment from information_schema.tables where table_name = 't28127_ai_max';

evaluate 'Case 6: with a negative increment, auto_increment shows the next id down to the minimum and NULL past it; result = 2, 2, 1, NULL';
-- AUTO_INCREMENT takes no negative increment, so ALTER SERIAL gives it one; no primary key, as the ids go back down
-- the serial of an AUTO_INCREMENT column takes its start value 1 as its minimum
create table t28127_ai_down (id int auto_increment, v int);
insert into t28127_ai_down (v) values (1), (2), (3), (4), (5);
alter serial t28127_ai_down_ai_id increment by -1;
-- ALTER SERIAL drops the cached block, so the INSERT after it reserves a new block, which ends at the minimum
insert into t28127_ai_down (v) values (6), (7);
select auto_increment from information_schema.tables where table_name = 't28127_ai_down';
insert into t28127_ai_down (v) values (8);
select id from t28127_ai_down where v = 8;
select auto_increment from information_schema.tables where table_name = 't28127_ai_down';
insert into t28127_ai_down (v) values (9);
select auto_increment from information_schema.tables where table_name = 't28127_ai_down';

evaluate 'Case 7: current_val of a cached serial is the last value NEXT_VALUE gave; result = 3, 3, 3';
create serial s28127_cached cache 10;
select s28127_cached.next_value from db_root;
select s28127_cached.next_value from db_root;
select s28127_cached.next_value from db_root;
select current_val from db_serial where name = 's28127_cached';
-- CURRENT_VALUE and SERIAL_CURRENT_VALUE read the serial without the db_serial view
select s28127_cached.current_value, serial_current_value (s28127_cached) from db_root;

evaluate 'Case 8: current_val of a serial that has given no value is its start value; result = 5';
create serial s28127_unused start with 5 cache 10;
select current_val from db_serial where name = 's28127_unused';

evaluate 'Case 9: in a correlated subquery, serial_current_value_by_oid gives the value NEXT_VALUE gave in the same row; result = 1 to 5 in both columns';
create table t28127_rows (n int);
insert into t28127_rows values (1), (2), (3), (4), (5);
-- cache 10 keeps the block end (10) in _db_serial, so only a read of the serial cache gives the value NEXT_VALUE gave
create serial s28127_rows cache 10;
-- every row joins the same _db_serial row s: a subquery result cache keyed on s would reuse the first row's value
select s28127_rows.next_value, (select serial_current_value_by_oid (s) from db_root)
from _db_serial s, t28127_rows r
where s.name = 's28127_rows'
order by 1;

evaluate 'Case 10: serial_current_value_by_oid takes only a _db_serial alias; result = 5, s28127_rows, then the same error five times';
-- s28127_rows has given values with NEXT_VALUE in Case 9
create table t28127_oid (o _db_serial);
insert into t28127_oid select s from _db_serial s where s.name = 's28127_rows';
select serial_current_value_by_oid (s) from _db_serial s where s.name = 's28127_rows';
-- the statement with serial_current_value_by_oid (s) > 0 below, without that condition: its error then comes from that function
select s.name from _db_serial s where s = (select o from t28127_oid);
-- an alias of another class, an alias of _db_serial and another class, an object column, a host variable,
-- and an alias that a rewrite replaces with the subquery column
select serial_current_value_by_oid (r) from db_root r;
select serial_current_value_by_oid (s) from (_db_serial, db_root) s;
select serial_current_value_by_oid (o) from t28127_oid;
prepare q28127 from 'select serial_current_value_by_oid (?) from db_root';
select s.name from _db_serial s where s = (select o from t28127_oid) and serial_current_value_by_oid (s) > 0;

evaluate 'Case 11: for a user outside the DBA group, auto_increment is the id the next INSERT gets and current_val the last value NEXT_VALUE gave; result = 3, 1';
create user u28127_viewer;
call login ('u28127_viewer', '') on class db_user;
select current_user from db_root;
drop table if exists t28127_user_ai;
drop serial if exists s28127_user;
create table t28127_user_ai (id int auto_increment primary key, v int);
insert into t28127_user_ai (v) values (1), (2);
create serial s28127_user cache 10;
select s28127_user.next_value from db_root;
select auto_increment from information_schema.tables where table_name = 't28127_user_ai';
select current_val from db_serial where name = 's28127_user';
drop table t28127_user_ai;
drop serial s28127_user;
call login ('dba', '') on class db_user;
drop user u28127_viewer;

evaluate 'Case 12: a condition on current_val is checked outside the unmerged db_serial view; result = s28127_unused 5';
-- s28127_unused from Case 8 has given no value
--@queryplan
select name, current_val from db_serial where name = 's28127_unused' and current_val = 5;

evaluate 'Case 13: past the BIGINT range, current_val of a cached serial is the last value NEXT_VALUE gave, going up and going down; result = 9223372036854775811, -9223372036854775811';
-- the serial cache keeps a value past the BIGINT range apart from the values it counts within that range
create serial s28127_above_bigint start with 9223372036854775810 cache 10;
select s28127_above_bigint.next_value from db_root;
select s28127_above_bigint.next_value from db_root;
select current_val from db_serial where name = 's28127_above_bigint';
create serial s28127_below_bigint start with -9223372036854775810 increment by -1 cache 10;
select s28127_below_bigint.next_value from db_root;
select s28127_below_bigint.next_value from db_root;
select current_val from db_serial where name = 's28127_below_bigint';

drop table t28127_ai, t28127_ai_start, t28127_no_ai, t28127_ai_max, t28127_ai_down, t28127_rows, t28127_oid;
drop serial s28127_cached;
drop serial s28127_unused;
drop serial s28127_rows;
drop serial s28127_above_bigint;
drop serial s28127_below_bigint;
