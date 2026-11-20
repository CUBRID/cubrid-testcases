/**
 *  This test case verifies CBRD-27381: a foreign key added over existing rows is checked against the index the build sorted
 *
 *  ALTER TABLE ADD FOREIGN KEY builds the index of the foreign key from the rows, then walks it with the
 *  index of the primary key - forward when every column runs the way of the primary key, backward when
 *  every column runs the other way, and one lookup per key when the directions mix. t_r and t_c hold the
 *  same rows. Each foreign key is added to t_r with index_sort_method=radix and to t_c with compare, both
 *  with index_build_buffer_size 64K so a build sorts several runs. With a row that has no parent both must
 *  fail with the same error. Without it both must succeed, and each radix-built foreign key index must read
 *  back as its twin and find as many rows.
 *
 *  Rows: g is the row generator of 6000 rows in four shapes of 1500 (scattered, ascending, descending, few
 *  distinct values) with a NULL every 101st row, so a foreign key value repeats and is sometimes NULL.
 *
 *  Coverage:
 *    Case 1:  with a row that has no parent, a BIGINT foreign key to an ascending primary key and to a descending
 *             one, and an (INT, INT) foreign key to an (ASC, DESC) primary key fail under both methods
 *    Case 2:  without that row, the same foreign keys are added under both methods, and each radix-built index
 *             reads back in the order of the compare-built twin
 *    Case 3:  each radix-built foreign key index finds the rows whose key is not NULL
 *    Case 4:  the foreign keys hold - a row without a parent is refused
 */

drop table if exists t_r;
drop table if exists t_c;
drop table if exists pa;
drop table if exists pd;
drop table if exists pm;
drop table if exists g;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table pa (pk bigint primary key);
create table pd (pk bigint, primary key (pk desc));
create table pm (a int, b int, primary key (a, b desc));
create table t_r (id int, k1 bigint, k2 bigint, a int, b int);
create table t_c (id int, k1 bigint, k2 bigint, a int, b int);

insert into t_r select n, cast (v as bigint) * 1000003, cast (v as bigint) * 1000003, mod (v, 50), mod (n, 7) from g order by n;
insert into t_c select * from t_r order by id;
insert into pa select distinct k1 from t_r where k1 is not null;
insert into pd select distinct k1 from t_r where k1 is not null;
insert into pm select distinct a, b from t_r where a is not null;

evaluate 'Case 1: with a row that has no parent, each foreign key fails under both methods';
-- a row without a parent
insert into t_r values (9001, 1, 1, 99, 99);
insert into t_c values (9001, 1, 1, 99, 99);

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
alter table t_r add constraint fk_ra foreign key (k1) references pa (pk);
alter table t_r add constraint fk_rd foreign key (k2) references pd (pk);
alter table t_r add constraint fk_rm foreign key (a, b) references pm (a, b);
set system parameters 'index_sort_method=compare';
alter table t_c add constraint fk_ca foreign key (k1) references pa (pk);
alter table t_c add constraint fk_cd foreign key (k2) references pd (pk);
alter table t_c add constraint fk_cm foreign key (a, b) references pm (a, b);


evaluate 'Case 2: without that row, each foreign key is added under both methods and reads back in the order of the compare-built twin; result = no rows differ';
delete from t_r where id = 9001;
delete from t_c where id = 9001;
set system parameters 'index_sort_method=radix';
alter table t_r add constraint fk_ra foreign key (k1) references pa (pk);
alter table t_r add constraint fk_rd foreign key (k2) references pd (pk);
alter table t_r add constraint fk_rm foreign key (a, b) references pm (a, b);
set system parameters 'index_sort_method=compare';
alter table t_c add constraint fk_ca foreign key (k1) references pa (pk);
alter table t_c add constraint fk_cd foreign key (k2) references pd (pk);
alter table t_c add constraint fk_cm foreign key (a, b) references pm (a, b);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- each query prints the position and the key of the rows that differ from the compare-built twin
select 'ka' as ix, x.* from ((select rownum, k1 from t_r where k1 >= -9223372036854775807 using index fk_ra)
  difference (select rownum, k1 from t_c where k1 >= -9223372036854775807 using index fk_ca)) x order by 2;
select 'kd' as ix, x.* from ((select rownum, k2 from t_r where k2 >= -9223372036854775807 using index fk_rd)
  difference (select rownum, k2 from t_c where k2 >= -9223372036854775807 using index fk_cd)) x order by 2;
select 'm' as ix, x.* from ((select rownum, a, b from t_r where a >= -100 using index fk_rm)
  difference (select rownum, a, b from t_c where a >= -100 using index fk_cm)) x order by 2;

evaluate 'Case 3: each radix-built foreign key index finds the rows whose key is not NULL';
select count(*) from t_r where k1 >= -9223372036854775807 using index fk_ra;
select count(*) from t_r where k2 >= -9223372036854775807 using index fk_rd;
select count(*) from t_r where a >= -100 using index fk_rm;

evaluate 'Case 4: the foreign keys hold - a row without a parent is refused under both methods';
insert into t_r values (9002, 1, null, null, null);
insert into t_c values (9002, 1, null, null, null);

drop table t_r;
drop table t_c;
drop table pa;
drop table pd;
drop table pm;
drop table g;
