/**
 * CBRD-27463 (CUBRID/cubrid#8198): a foreign key check without the parent row lock.
 *
 * An UPDATE that does not set the referencing column skips the foreign key check of that column.
 * On a self-referencing table the same UPDATE can change the referenced key, and the skip then
 * let a key UPDATE under ON UPDATE SET NULL commit a row that refers to no row.
 * A self-referencing foreign key is never skipped. Each case checks the rows after the UPDATE
 * and that no row refers to a missing row. Cases 1, 4, 5 and 10 also read the rows that refer
 * to the old key through the foreign key index and through a heap scan, and the two agree.
 *
 * Coverage:
 *   Case 1: SET NULL, one row that refers to itself, key UPDATE fails
 *   Case 2: RESTRICT, the same row, key UPDATE fails
 *   Case 3: NO ACTION, the same row, key UPDATE fails
 *   Case 4: SET NULL, another row refers to the changed row as well, key UPDATE fails
 *   Case 5: SET NULL, one statement changes several keys, key UPDATE fails
 *   Case 6: SET NULL, two rows refer to each other, both keys change, the references become NULL
 *   Case 7: SET NULL, the referencing column is in the SET list unchanged, key UPDATE fails
 *   Case 8: SET NULL, key and reference change to the same new value, UPDATE succeeds
 *   Case 9: SET NULL, key changes and the reference is set to NULL, UPDATE succeeds
 *   Case 10: SET NULL, rows met in heap order where one row takes the old key, key UPDATE fails
 *   Case 11: SET NULL, a chain of references, all keys change, the references become NULL
 *   Case 12: control, separate parent and child tables, the child reference becomes NULL
 *   Case 13: control, one UPDATE of a parent and its child through a join, the reference becomes NULL
 */

evaluate 'Case 1: SET NULL, a row that refers to itself, key UPDATE fails with a foreign key error';
drop table if exists t27463_s1;
create table t27463_s1 (id int primary key, mgr int, v int, constraint fk_t27463_s1_mgr foreign key (mgr) references t27463_s1 (id) on update set null);
insert into t27463_s1 values (1, 1, 10);
update t27463_s1 set id = 101 where id = 1;
select id, mgr, v from t27463_s1 order by id;
select count(*) as dangling from t27463_s1 c where c.mgr is not null and not exists (select 1 from t27463_s1 p where p.id = c.mgr);
select /*+ recompile */ 'fk index' as via, id from t27463_s1 where mgr = 1 using index fk_t27463_s1_mgr(+) order by id;
select /*+ recompile */ 'heap' as via, id from t27463_s1 where mgr = 1 using index none order by id;

evaluate 'Case 2: RESTRICT, the same row, key UPDATE fails with a foreign key error';
drop table if exists t27463_s2;
create table t27463_s2 (id int primary key, mgr int, v int, constraint fk_t27463_s2_mgr foreign key (mgr) references t27463_s2 (id) on update restrict);
insert into t27463_s2 values (1, 1, 10);
update t27463_s2 set id = 101 where id = 1;
select id, mgr, v from t27463_s2 order by id;
select count(*) as dangling from t27463_s2 c where c.mgr is not null and not exists (select 1 from t27463_s2 p where p.id = c.mgr);

evaluate 'Case 3: NO ACTION, the same row, key UPDATE fails with a foreign key error';
drop table if exists t27463_s3;
create table t27463_s3 (id int primary key, mgr int, v int, constraint fk_t27463_s3_mgr foreign key (mgr) references t27463_s3 (id) on update no action);
insert into t27463_s3 values (1, 1, 10);
update t27463_s3 set id = 101 where id = 1;
select id, mgr, v from t27463_s3 order by id;
select count(*) as dangling from t27463_s3 c where c.mgr is not null and not exists (select 1 from t27463_s3 p where p.id = c.mgr);

evaluate 'Case 4: SET NULL, another row refers to the changed row too, key UPDATE fails with a foreign key error';
drop table if exists t27463_s4;
create table t27463_s4 (id int primary key, mgr int, v int, constraint fk_t27463_s4_mgr foreign key (mgr) references t27463_s4 (id) on update set null);
insert into t27463_s4 values (1, 1, 10), (2, 1, 20);
update t27463_s4 set id = 101 where id = 1;
select id, mgr, v from t27463_s4 order by id;
select count(*) as dangling from t27463_s4 c where c.mgr is not null and not exists (select 1 from t27463_s4 p where p.id = c.mgr);
select /*+ recompile */ 'fk index' as via, id from t27463_s4 where mgr = 1 using index fk_t27463_s4_mgr(+) order by id;
select /*+ recompile */ 'heap' as via, id from t27463_s4 where mgr = 1 using index none order by id;

evaluate 'Case 5: SET NULL, one statement changes several keys, key UPDATE fails with a foreign key error';
drop table if exists t27463_s5;
create table t27463_s5 (id int primary key, mgr int, v int, constraint fk_t27463_s5_mgr foreign key (mgr) references t27463_s5 (id) on update set null);
insert into t27463_s5 values (1, 1, 10), (2, 2, 20), (3, 1, 30);
update t27463_s5 set id = id + 100;
select id, mgr, v from t27463_s5 order by id;
select count(*) as dangling from t27463_s5 c where c.mgr is not null and not exists (select 1 from t27463_s5 p where p.id = c.mgr);
select /*+ recompile */ 'fk index' as via, id from t27463_s5 where mgr = 1 using index fk_t27463_s5_mgr(+) order by id;
select /*+ recompile */ 'heap' as via, id from t27463_s5 where mgr = 1 using index none order by id;

evaluate 'Case 6: SET NULL, two rows refer to each other, both keys change, both references become NULL';
drop table if exists t27463_s6;
create table t27463_s6 (id int primary key, mgr int, v int, constraint fk_t27463_s6_mgr foreign key (mgr) references t27463_s6 (id) on update set null);
insert into t27463_s6 values (1, null, 10), (2, 1, 20);
update t27463_s6 set mgr = 2 where id = 1;
update t27463_s6 set id = id + 100;
select id, mgr, v from t27463_s6 order by id;
select count(*) as dangling from t27463_s6 c where c.mgr is not null and not exists (select 1 from t27463_s6 p where p.id = c.mgr);

evaluate 'Case 7: SET NULL, the referencing column is in the SET list unchanged, key UPDATE fails with a foreign key error';
drop table if exists t27463_s7;
create table t27463_s7 (id int primary key, mgr int, v int, constraint fk_t27463_s7_mgr foreign key (mgr) references t27463_s7 (id) on update set null);
insert into t27463_s7 values (1, 1, 10);
update t27463_s7 set id = 101, mgr = mgr where id = 1;
select id, mgr, v from t27463_s7 order by id;
select count(*) as dangling from t27463_s7 c where c.mgr is not null and not exists (select 1 from t27463_s7 p where p.id = c.mgr);

evaluate 'Case 8: SET NULL, key and reference change to the same new value, the UPDATE succeeds';
drop table if exists t27463_s8;
create table t27463_s8 (id int primary key, mgr int, v int, constraint fk_t27463_s8_mgr foreign key (mgr) references t27463_s8 (id) on update set null);
insert into t27463_s8 values (1, 1, 10);
update t27463_s8 set id = 101, mgr = 101 where id = 1;
select id, mgr, v from t27463_s8 order by id;
select count(*) as dangling from t27463_s8 c where c.mgr is not null and not exists (select 1 from t27463_s8 p where p.id = c.mgr);
select /*+ recompile */ 'fk index' as via, id from t27463_s8 where mgr = 101 using index fk_t27463_s8_mgr(+) order by id;

evaluate 'Case 9: SET NULL, key changes and the reference is set to NULL, the UPDATE succeeds';
drop table if exists t27463_s9;
create table t27463_s9 (id int primary key, mgr int, v int, constraint fk_t27463_s9_mgr foreign key (mgr) references t27463_s9 (id) on update set null);
insert into t27463_s9 values (1, 1, 10);
update t27463_s9 set id = 101, mgr = null where id = 1;
select id, mgr, v from t27463_s9 order by id;
select count(*) as dangling from t27463_s9 c where c.mgr is not null and not exists (select 1 from t27463_s9 p where p.id = c.mgr);

evaluate 'Case 10: SET NULL, the first row met takes the old key of the second, key UPDATE fails with a foreign key error';
-- rows are inserted in this order so that the scan meets the row (2, NULL) before the row (1, 1)
drop table if exists t27463_s10;
create table t27463_s10 (id int primary key, mgr int, v int, constraint fk_t27463_s10_mgr foreign key (mgr) references t27463_s10 (id) on update set null);
insert into t27463_s10 values (2, null, 20);
insert into t27463_s10 values (1, 1, 10);
update t27463_s10 set id = case id when 2 then 1 else 101 end;
select id, mgr, v from t27463_s10 order by id;
select count(*) as dangling from t27463_s10 c where c.mgr is not null and not exists (select 1 from t27463_s10 p where p.id = c.mgr);
select /*+ recompile */ 'fk index' as via, id from t27463_s10 where mgr = 1 using index fk_t27463_s10_mgr(+) order by id;
select /*+ recompile */ 'heap' as via, id from t27463_s10 where mgr = 1 using index none order by id;

evaluate 'Case 11: SET NULL, a chain of references, all keys change, the references become NULL';
drop table if exists t27463_s11;
create table t27463_s11 (id int primary key, mgr int, v int, constraint fk_t27463_s11_mgr foreign key (mgr) references t27463_s11 (id) on update set null);
-- rows are inserted in this order so that the scan meets each referencing row before the row it refers to
insert into t27463_s11 values (3, null, 30), (2, null, 20), (1, null, 10);
update t27463_s11 set mgr = 2 where id = 3;
update t27463_s11 set mgr = 1 where id = 2;
update t27463_s11 set id = id + 100;
select id, mgr, v from t27463_s11 order by id;
select count(*) as dangling from t27463_s11 c where c.mgr is not null and not exists (select 1 from t27463_s11 p where p.id = c.mgr);

evaluate 'Case 12: control, separate parent and child tables, the child reference becomes NULL';
drop table if exists t27463_c12;
drop table if exists t27463_p12;
create table t27463_p12 (id int primary key, v int);
create table t27463_c12 (id int primary key, pid int, constraint fk_t27463_c12_pid foreign key (pid) references t27463_p12 (id) on update set null);
insert into t27463_p12 values (1, 10);
insert into t27463_c12 values (1, 1);
update t27463_p12 set id = 101 where id = 1;
select id, v from t27463_p12 order by id;
select id, pid from t27463_c12 order by id;
select count(*) as dangling from t27463_c12 c where c.pid is not null and not exists (select 1 from t27463_p12 p where p.id = c.pid);

evaluate 'Case 13: control, one UPDATE of a parent key and its child through a join, the reference becomes NULL';
drop table if exists t27463_c13;
drop table if exists t27463_p13;
create table t27463_p13 (id int primary key, v int);
create table t27463_c13 (id int primary key, pid int, v int, constraint fk_t27463_c13_pid foreign key (pid) references t27463_p13 (id) on update set null);
insert into t27463_p13 values (1, 10);
insert into t27463_c13 values (1, 1, 0);
update t27463_p13 p, t27463_c13 c set p.id = 101, c.v = 1 where c.pid = p.id and p.id = 1;
select id, v from t27463_p13 order by id;
select id, pid, v from t27463_c13 order by id;
select count(*) as dangling from t27463_c13 c where c.pid is not null and not exists (select 1 from t27463_p13 p where p.id = c.pid);

drop table if exists t27463_s1;
drop table if exists t27463_s2;
drop table if exists t27463_s3;
drop table if exists t27463_s4;
drop table if exists t27463_s5;
drop table if exists t27463_s6;
drop table if exists t27463_s7;
drop table if exists t27463_s8;
drop table if exists t27463_s9;
drop table if exists t27463_s10;
drop table if exists t27463_s11;
drop table if exists t27463_c12;
drop table if exists t27463_p12;
drop table if exists t27463_c13;
drop table if exists t27463_p13;
