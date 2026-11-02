/**
 *  CBRD-27837: Adding a foreign key that references the superclass to a subclass must keep the
 *  inherited primary key and unique keys on their own columns.
 *
 *  Allocating the foreign key updates the referenced superclass, and that update reinstalls the
 *  subclass while its constraints are still being written. The inherited key constraints pointed
 *  to the freed attributes of the subclass, so the id of whatever reused that memory was written
 *  as the key column: the primary key of t27837_c could move to b, a column of a multi-column key
 *  could get an empty name, and later inserts were checked on the wrong column.
 *
 *  The result depended on the memory layout of the workspace, so the three tables t27837_f1~f3
 *  come first to make the layout of the issue report. A build without the fix does not fail on
 *  every run.
 *
 *  Coverage:
 *  1    inherited primary key, then an insert that the moved key would reject
 *  2    inherited unique key
 *  3    multi-column primary key with a two-column foreign key
 *  4    control: foreign key to a class outside the hierarchy
 *  5    control: index instead of a foreign key
 *  6    control: foreign key to the subclass itself
 */

drop table if exists t27837_c;
drop table if exists t27837_p;
drop table if exists t27837_x;
drop table if exists t27837_f1, t27837_f2, t27837_f3;

create table t27837_f1 (c1 int, c2 int, c3 int);
create table t27837_f2 (c1 int, c2 int, c3 int);
create table t27837_f3 (c1 int, c2 int, c3 int);


evaluate 'Case 1: inherited primary key, then an insert that the moved key would reject';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
insert into t27837_p (a) values (1);
insert into t27837_c (a, b) values (2, 1);
select a, b from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 2: inherited unique key';
create table t27837_p (a int, u int, primary key (a), unique (u));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 3: multi-column primary key with a two-column foreign key';
create table t27837_p (a int, a2 int, primary key (a, a2));
create table t27837_c under t27837_p (b int, b2 int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b, b2) references t27837_p (a, a2);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 4: control, foreign key to a class outside the hierarchy';
create table t27837_x (x int, primary key (x));
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_x (x);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;
drop table t27837_x;


evaluate 'Case 5: control, index instead of a foreign key';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
create index i_t27837_c_b on t27837_c (b);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 6: control, foreign key to the subclass itself';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_c (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


drop table t27837_f1, t27837_f2, t27837_f3;
