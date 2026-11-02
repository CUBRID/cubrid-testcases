/**
 *  CBRD-27019: a cached serial hands out its values with a lock-free draw count.
 *
 *  A cached serial that does not cycle and whose values fit BIGINT now counts the values it hands
 *  out in an atomic counter: the k-th value is the last value issued before the entry opened plus
 *  k times the increment. Only a draw past the end of the reserved block takes the entry mutex to
 *  reserve the next block. At the end of the range, past the BIGINT end, for a block of more than
 *  INT_MAX values, or when the block is wider than BIGINT can count, the entry goes back to the
 *  existing path. A decache (ALTER SERIAL) closes the count and writes the last issued value back.
 *  The values, the errors, CURRENT_VALUE and the value left in db_serial must stay the same as
 *  before the change, so this file passes without the change as well.
 *
 *  Values are read through a derived table with LIMIT, so each statement draws exactly that many
 *  values, and the outer ORDER BY gives the order in which they were drawn. Where only the range of
 *  many values is checked, the values go into t27019_v first: an aggregate over the derived table
 *  evaluates NEXT_VALUE again for each reference to v.
 *
 *  Coverage:
 *    Case 1:  MAXVALUE off the increment grid: the range error after the last value
 *    Case 2:  values running past the BIGINT end
 *    Case 3:  an increment larger than INT_MAX
 *    Case 4:  a negative increment crossing zero
 *    Case 5:  NOCACHE after cases 2 and 4: the next value follows the last one
 *    Case 6:  SERIAL_NEXT_VALUE (s, n) failing at the range end keeps the remaining values
 *    Case 7:  dense values, SERIAL_NEXT_VALUE (s, n) with n = 1, n < cache, n > cache
 *    Case 8:  CYCLE (the existing path from the start)
 *    Case 9:  a negative increment, write-back on ALTER ... CACHE
 *    Case 10: values crossing 2^62
 *    Case 11: write-back on ALTER ... CACHE, then NOCACHE and CACHE again
 *    Case 12: AUTO_INCREMENT
 *    Case 13: repeated SERIAL_NEXT_VALUE (s, 2^30) calls failing at the range end
 *    Case 14: SERIAL_NEXT_VALUE (s, 2147483647), a block of more than INT_MAX values
 *    Case 15: single draws past the range end, then ALTER ... MAXVALUE
 *    Case 16: write-back on ALTER right after a failed SERIAL_NEXT_VALUE (s, n)
 *    Case 17: the first draw fails while the cache entry is installed
 *    Case 18: a negative increment and MINVALUE off the increment grid
 *    Case 19: crossing zero, SERIAL_NEXT_VALUE (s, n), write-back on ALTER ... CACHE
 *    Case 20: a block wider than BIGINT can count (the existing path from the start)
 *    Case 21: a negative increment, SERIAL_NEXT_VALUE (s, n)
 *    Case 22: values running past the negative BIGINT end, then NOCACHE
 */

drop table if exists t27019, t27019_ai, t27019_v;
drop serial if exists s27019_1;
drop serial if exists s27019_2;
drop serial if exists s27019_3;
drop serial if exists s27019_4;
drop serial if exists s27019_6;
drop serial if exists s27019_7;
drop serial if exists s27019_8;
drop serial if exists s27019_9;
drop serial if exists s27019_10;
drop serial if exists s27019_11;
drop serial if exists s27019_13;
drop serial if exists s27019_14;
drop serial if exists s27019_15;
drop serial if exists s27019_16;
drop serial if exists s27019_17;
drop serial if exists s27019_18;
drop serial if exists s27019_19;
drop serial if exists s27019_20;
drop serial if exists s27019_21;
drop serial if exists s27019_22;

create table t27019 (i int);
insert into t27019 select rownum from db_class a, db_class b limit 1000;
select count(*) from t27019;
create table t27019_v (v numeric(38));


evaluate 'Case 1: MAXVALUE 9 off the grid of 3: 1, 4, 7, then the range error; CURRENT_VALUE stays 7';
create serial s27019_1 start with 1 increment by 3 maxvalue 9 cache 2;
select v from (select s27019_1.next_value v from t27019 limit 3) x order by v;
select s27019_1.current_value from db_root;
select s27019_1.next_value from db_root;
select s27019_1.current_value from db_root;


evaluate 'Case 2: 9223372036854775800 to 9223372036854775811, past the BIGINT end';
create serial s27019_2 start with 9223372036854775800 cache 5;
select v from (select s27019_2.next_value v from t27019 limit 12) x order by v;
select s27019_2.current_value from db_root;


evaluate 'Case 3: an increment of 3000000000: 0 to 12000000000';
create serial s27019_3 start with 0 increment by 3000000000 cache 10;
select v from (select s27019_3.next_value v from t27019 limit 5) x order by v;
select s27019_3.current_value from db_root;


evaluate 'Case 4: an increment of -2 from 5: 5 to -9';
create serial s27019_4 start with 5 increment by -2 minvalue -100 cache 3;
select v from (select s27019_4.next_value v from t27019 limit 8) x order by v desc;
select s27019_4.current_value from db_root;


evaluate 'Case 5: NOCACHE: 9223372036854775812 after case 2, -11 after case 4';
alter serial s27019_2 nocache;
select s27019_2.next_value from db_root;
alter serial s27019_4 nocache;
select s27019_4.next_value from db_root;


evaluate 'Case 6: 95 of 100 values, SERIAL_NEXT_VALUE (s, 10) fails, then 96 to 100, the range error, and 101 after MAXVALUE 200';
create serial s27019_6 start with 1 maxvalue 100 cache 10;
insert into t27019_v select s27019_6.next_value from t27019 limit 95;
select min(v), max(v), count(*) from t27019_v;
delete from t27019_v;
select s27019_6.current_value from db_root;
select serial_next_value (s27019_6, 10) from db_root;
select s27019_6.current_value from db_root;
select v from (select s27019_6.next_value v from t27019 limit 5) x order by v;
select s27019_6.next_value from db_root;
select s27019_6.current_value from db_root;
alter serial s27019_6 maxvalue 200;
select v from (select s27019_6.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 7: CACHE 5: 1 to 12, 13 to 112, then SERIAL_NEXT_VALUE with 3, 1 and 12 values';
create serial s27019_7 start with 1 cache 5;
select v from (select s27019_7.next_value v from t27019 limit 12) x order by v;
select s27019_7.current_value from db_root;
insert into t27019_v select s27019_7.next_value from t27019 limit 100;
select min(v), max(v), count(*) from t27019_v;
delete from t27019_v;
select s27019_7.current_value from db_root;
select serial_next_value (s27019_7, 3) from db_root;
select s27019_7.current_value from db_root;
select serial_next_value (s27019_7, 1) from db_root;
select serial_next_value (s27019_7, 12) from db_root;
select s27019_7.current_value from db_root;
select v from (select s27019_7.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 8: MAXVALUE 7 CYCLE: 1 to 7, then 1, 2, 3';
create serial s27019_8 start with 1 maxvalue 7 cycle cache 3;
select v from (select s27019_8.next_value v from t27019 limit 10) x order by v;
select s27019_8.current_value from db_root;


evaluate 'Case 9: an increment of -3 from 10, ALTER ... CACHE 5 writes -5 back, then -8, -11';
create serial s27019_9 start with 10 increment by -3 minvalue -20 cache 4;
select v from (select s27019_9.next_value v from t27019 limit 6) x order by v desc;
select s27019_9.current_value from db_root;
alter serial s27019_9 cache 5;
select current_val from db_serial where name = 's27019_9';
select v from (select s27019_9.next_value v from t27019 limit 2) x order by v desc;


evaluate 'Case 10: 14 values from 4611686018427387895, across 2^62';
create serial s27019_10 start with 4611686018427387895 cache 4;
select v from (select s27019_10.next_value v from t27019 limit 14) x order by v;
select s27019_10.current_value from db_root;


evaluate 'Case 11: CACHE 100, 37 values, ALTER ... CACHE 50 writes 37 back, then NOCACHE and CACHE 20 continue';
create serial s27019_11 start with 1 cache 100;
insert into t27019_v select s27019_11.next_value from t27019 limit 37;
select min(v), max(v), count(*) from t27019_v;
delete from t27019_v;
alter serial s27019_11 cache 50;
select current_val from db_serial where name = 's27019_11';
select v from (select s27019_11.next_value v from t27019 limit 3) x order by v;
alter serial s27019_11 nocache;
select v from (select s27019_11.next_value v from t27019 limit 3) x order by v;
alter serial s27019_11 cache 20;
select v from (select s27019_11.next_value v from t27019 limit 3) x order by v;
select s27019_11.current_value from db_root;


evaluate 'Case 12: AUTO_INCREMENT: 10 rows get 1 to 10';
create table t27019_ai (id int auto_increment, x int);
insert into t27019_ai (x) select 1 from t27019 limit 10;
select min(id), max(id), count(distinct id) from t27019_ai;


evaluate 'Case 13: SERIAL_NEXT_VALUE (s, 2^30) 18 times: 4 succeed, 14 fail with the range error';
create serial s27019_13 increment by 1073741824 maxvalue 4611686018427387904 cache 2;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select serial_next_value (s27019_13, 1073741824) from db_root;
select s27019_13.current_value from db_root;


evaluate 'Case 14: CACHE 2, 1 and 2, SERIAL_NEXT_VALUE (s, 2147483647), then the next two values';
create serial s27019_14 start with 1 cache 2;
select v from (select s27019_14.next_value v from t27019 limit 2) x order by v;
select serial_next_value (s27019_14, 2147483647) from db_root;
select s27019_14.current_value from db_root;
select v from (select s27019_14.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 15: all 100 values, two single draws fail with the range error, then 101 and 102 after MAXVALUE 200';
create serial s27019_15 start with 1 maxvalue 100 cache 10;
insert into t27019_v select s27019_15.next_value from t27019 limit 100;
select min(v), max(v), count(*) from t27019_v;
delete from t27019_v;
select s27019_15.next_value from db_root;
select s27019_15.next_value from db_root;
select s27019_15.current_value from db_root;
alter serial s27019_15 maxvalue 200;
select v from (select s27019_15.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 16: 95 values, SERIAL_NEXT_VALUE (s, 10) fails, ALTER ... MAXVALUE 200 writes 95 back, then 96, 97';
create serial s27019_16 start with 1 maxvalue 100 cache 10;
insert into t27019_v select s27019_16.next_value from t27019 limit 95;
select min(v), max(v), count(*) from t27019_v;
delete from t27019_v;
select serial_next_value (s27019_16, 10) from db_root;
alter serial s27019_16 maxvalue 200;
select current_val from db_serial where name = 's27019_16';
select v from (select s27019_16.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 17: MAXVALUE 5 CACHE 3: the first draw SERIAL_NEXT_VALUE (s, 10) fails, then 1, 2';
create serial s27019_17 start with 1 maxvalue 5 cache 3;
select serial_next_value (s27019_17, 10) from db_root;
select v from (select s27019_17.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 18: an increment of -3, MINVALUE -11 off the grid: -1 to -10, then the range error; CURRENT_VALUE stays -10';
create serial s27019_18 start with -1 increment by -3 minvalue -11 maxvalue -1 cache 2;
select v from (select s27019_18.next_value v from t27019 limit 4) x order by v desc;
select s27019_18.next_value from db_root;
select s27019_18.current_value from db_root;


evaluate 'Case 19: -5 to 2, SERIAL_NEXT_VALUE (s, 3) gives 5, ALTER ... CACHE 3 writes 5 back, then 6, 7';
create serial s27019_19 start with -5 minvalue -10 cache 4;
select v from (select s27019_19.next_value v from t27019 limit 8) x order by v;
select serial_next_value (s27019_19, 3) from db_root;
select s27019_19.current_value from db_root;
alter serial s27019_19 cache 3;
select current_val from db_serial where name = 's27019_19';
select v from (select s27019_19.next_value v from t27019 limit 2) x order by v;


evaluate 'Case 20: an increment of 2^62 from -9223372036854775000: 5 values';
create serial s27019_20 start with -9223372036854775000 increment by 4611686018427387904 minvalue -9223372036854775000 cache 3;
select v from (select s27019_20.next_value v from t27019 limit 5) x order by v;
select s27019_20.current_value from db_root;


evaluate 'Case 21: an increment of -2 from -1: -1, -3, -5, SERIAL_NEXT_VALUE (s, 5) gives -15, then -17, -19';
create serial s27019_21 start with -1 increment by -2 maxvalue -1 cache 4;
select v from (select s27019_21.next_value v from t27019 limit 3) x order by v desc;
select serial_next_value (s27019_21, 5) from db_root;
select s27019_21.current_value from db_root;
select v from (select s27019_21.next_value v from t27019 limit 2) x order by v desc;


evaluate 'Case 22: -9223372036854775800 to -9223372036854775811, past the negative BIGINT end, then -9223372036854775812 after NOCACHE';
create serial s27019_22 start with -9223372036854775800 increment by -1 minvalue -9223372036854775900 cache 5;
select v from (select s27019_22.next_value v from t27019 limit 12) x order by v desc;
select s27019_22.current_value from db_root;
alter serial s27019_22 nocache;
select s27019_22.next_value from db_root;


drop table if exists t27019, t27019_ai, t27019_v;
drop serial if exists s27019_1;
drop serial if exists s27019_2;
drop serial if exists s27019_3;
drop serial if exists s27019_4;
drop serial if exists s27019_6;
drop serial if exists s27019_7;
drop serial if exists s27019_8;
drop serial if exists s27019_9;
drop serial if exists s27019_10;
drop serial if exists s27019_11;
drop serial if exists s27019_13;
drop serial if exists s27019_14;
drop serial if exists s27019_15;
drop serial if exists s27019_16;
drop serial if exists s27019_17;
drop serial if exists s27019_18;
drop serial if exists s27019_19;
drop serial if exists s27019_20;
drop serial if exists s27019_21;
drop serial if exists s27019_22;
