/**
 *  CBRD-27837: Adding a foreign key that references the superclass to a subclass must keep the
 *  inherited primary key and unique keys on their own columns.
 *
 *  Allocating the foreign key updates the referenced superclass, and that update reinstalls the
 *  subclass while its constraints are still being written. The inherited key constraints pointed
 *  to the freed attributes of the subclass, so the id of whatever reused that memory was written
 *  as the key column: the primary key of a subclass could move to b, a column of a multi-column
 *  key could get an empty name, and later inserts were checked on the wrong column.
 *
 *  The result depends on the memory layout of the workspace of the process that runs the
 *  statements. Case 1 comes first, before any other statement, because that order makes a build
 *  without the fix record b as the primary key of t27837_c7 in this test environment; a statement
 *  added before it can change the layout so that the case no longer fails without the fix. On a
 *  debug server without the fix, the drop of t27837_p7 then stops the server. The tables
 *  t27837_f1~f3 in the other cases follow the layout of the issue report.
 *
 *  Coverage:
 *  1    seven hierarchies in a row: primary key, primary key with a unique key, and a two-column
 *       primary key, each subclass with a foreign key that references its superclass
 *  2    inherited primary key, then an insert that the moved key would reject
 *  3    inherited unique key
 *  4    multi-column primary key with a two-column foreign key
 *  5    control: foreign key to a class outside the hierarchy
 *  6    control: index instead of a foreign key
 *  7    control: foreign key to the subclass itself
 */

evaluate 'Case 1: seven hierarchies in a row, each subclass gets a foreign key that references its superclass';
create table t27837_p1 (a int, primary key (a));
create table t27837_c1 under t27837_p1 (b int);
alter table t27837_c1 add constraint fk_t27837_c1 foreign key (b) references t27837_p1 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c1' and index_name not like 'fk%' order by index_name, key_order;
create table t27837_p2 (a int, u int, primary key (a), unique (u));
create table t27837_c2 under t27837_p2 (b int);
alter table t27837_c2 add constraint fk_t27837_c2 foreign key (b) references t27837_p2 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c2' and index_name not like 'fk%' order by index_name, key_order;
create table t27837_p3 (a int, a2 int, primary key (a, a2));
create table t27837_c3 under t27837_p3 (b int, b2 int);
alter table t27837_c3 add constraint fk_t27837_c3 foreign key (b, b2) references t27837_p3 (a, a2);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c3' and index_name not like 'fk%' order by index_name, key_order;
create table t27837_p4 (a int, primary key (a));
create table t27837_c4 under t27837_p4 (b int);
alter table t27837_c4 add constraint fk_t27837_c4 foreign key (b) references t27837_p4 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c4' and index_name not like 'fk%' order by index_name, key_order;
create table t27837_p5 (a int, u int, primary key (a), unique (u));
create table t27837_c5 under t27837_p5 (b int);
alter table t27837_c5 add constraint fk_t27837_c5 foreign key (b) references t27837_p5 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c5' and index_name not like 'fk%' order by index_name, key_order;
create table t27837_p6 (a int, a2 int, primary key (a, a2));
create table t27837_c6 under t27837_p6 (b int, b2 int);
alter table t27837_c6 add constraint fk_t27837_c6 foreign key (b, b2) references t27837_p6 (a, a2);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c6' and index_name not like 'fk%' order by index_name, key_order;
create table t27837_p7 (a int, primary key (a));
create table t27837_c7 under t27837_p7 (b int);
alter table t27837_c7 add constraint fk_t27837_c7 foreign key (b) references t27837_p7 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c7' and index_name not like 'fk%' order by index_name, key_order;
drop table t27837_c1;
drop table t27837_p1;
drop table t27837_c2;
drop table t27837_p2;
drop table t27837_c3;
drop table t27837_p3;
drop table t27837_c4;
drop table t27837_p4;
drop table t27837_c5;
drop table t27837_p5;
drop table t27837_c6;
drop table t27837_p6;
drop table t27837_c7;
drop table t27837_p7;

drop table if exists t27837_c;
drop table if exists t27837_p;
drop table if exists t27837_x;
drop table if exists t27837_f1, t27837_f2, t27837_f3;



create table t27837_f1 (c1 int, c2 int, c3 int);
create table t27837_f2 (c1 int, c2 int, c3 int);
create table t27837_f3 (c1 int, c2 int, c3 int);


evaluate 'Case 2: inherited primary key, then an insert that the moved key would reject';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
insert into t27837_p (a) values (1);
insert into t27837_c (a, b) values (2, 1);
select a, b from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 3: inherited unique key';
create table t27837_p (a int, u int, primary key (a), unique (u));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 4: multi-column primary key with a two-column foreign key';
create table t27837_p (a int, a2 int, primary key (a, a2));
create table t27837_c under t27837_p (b int, b2 int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b, b2) references t27837_p (a, a2);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 5: control, foreign key to a class outside the hierarchy';
create table t27837_x (x int, primary key (x));
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_x (x);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;
drop table t27837_x;


evaluate 'Case 6: control, index instead of a foreign key';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
create index i_t27837_c_b on t27837_c (b);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 7: control, foreign key to the subclass itself';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_c (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
drop table t27837_c;
drop table t27837_p;


drop table t27837_f1, t27837_f2, t27837_f3;
