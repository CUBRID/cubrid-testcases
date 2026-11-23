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
 *  debug server without the fix, the drop of t27837_p7 then stops the server.
 *
 *  For the same reason Case 1 has no drop if exists before its tables. When a run stops in the
 *  middle, as on a debug server without the fix, drop the tables t27837_p1~p7 and t27837_c1~c7
 *  before the next run, or Case 1 fails on the tables that are left.
 *
 *  The cases after Case 1 do not depend on the layout. Case 2 checks the key by the inserts that
 *  it accepts and rejects, and Cases 8~12 cover the other constraints and statements that the
 *  foreign key allocation passes through.
 *
 *  Coverage:
 *  1    seven hierarchies in a row: primary key, primary key with a unique key, and a two-column
 *       primary key, each subclass with a foreign key that references its superclass
 *  2    inherited primary key - a duplicate of a is rejected and a duplicate of b is accepted
 *  3    inherited unique key
 *  4    multi-column primary key with a two-column foreign key
 *  5    control: foreign key to a class outside the hierarchy
 *  6    control: index instead of a foreign key
 *  7    control: foreign key to the subclass itself
 *  8    inherited not null constraint - a null for n is rejected
 *  9    inherited shared attributes with not null constraints
 *  10   two foreign keys added to the subclass one after the other
 *  11   foreign key defined in the create statement of the subclass
 *  12   foreign keys that fail to be added - the keys stay on their columns, and a later add works
 */

evaluate 'Case 1: seven hierarchies in a row, each subclass gets a foreign key that references its superclass';
create table t27837_p1 (a int, primary key (a));
create table t27837_c1 under t27837_p1 (b int);
alter table t27837_c1 add constraint fk_t27837_c1 foreign key (b) references t27837_p1 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c1' order by index_name, key_order;
create table t27837_p2 (a int, u int, primary key (a), unique (u));
create table t27837_c2 under t27837_p2 (b int);
alter table t27837_c2 add constraint fk_t27837_c2 foreign key (b) references t27837_p2 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c2' order by index_name, key_order;
create table t27837_p3 (a int, a2 int, primary key (a, a2));
create table t27837_c3 under t27837_p3 (b int, b2 int);
alter table t27837_c3 add constraint fk_t27837_c3 foreign key (b, b2) references t27837_p3 (a, a2);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c3' order by index_name, key_order;
create table t27837_p4 (a int, primary key (a));
create table t27837_c4 under t27837_p4 (b int);
alter table t27837_c4 add constraint fk_t27837_c4 foreign key (b) references t27837_p4 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c4' order by index_name, key_order;
create table t27837_p5 (a int, u int, primary key (a), unique (u));
create table t27837_c5 under t27837_p5 (b int);
alter table t27837_c5 add constraint fk_t27837_c5 foreign key (b) references t27837_p5 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c5' order by index_name, key_order;
create table t27837_p6 (a int, a2 int, primary key (a, a2));
create table t27837_c6 under t27837_p6 (b int, b2 int);
alter table t27837_c6 add constraint fk_t27837_c6 foreign key (b, b2) references t27837_p6 (a, a2);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c6' order by index_name, key_order;
create table t27837_p7 (a int, primary key (a));
create table t27837_c7 under t27837_p7 (b int);
alter table t27837_c7 add constraint fk_t27837_c7 foreign key (b) references t27837_p7 (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c7' order by index_name, key_order;
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


evaluate 'Case 2: inherited primary key - a duplicate of a is rejected and a duplicate of b is accepted';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
insert into t27837_p (a) values (1);
insert into t27837_c (a, b) values (2, 1);
-- expected error: a is the primary key, so the same a is a unique violation
insert into t27837_c (a, b) values (2, 1);
-- b is not a key, so the same b is accepted
insert into t27837_c (a, b) values (3, 1);
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


evaluate 'Case 8: inherited not null constraint - a null for n is rejected';
create table t27837_p (a int, n int not null, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
select attr_name, is_nullable from db_attribute where class_name = 't27837_c' order by attr_name;
insert into t27837_p (a, n) values (1, 10);
-- expected error: n keeps its inherited not null constraint
insert into t27837_c (a, n, b) values (2, null, 1);
insert into t27837_c (a, n, b) values (2, 20, 1);
select a, n, b from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 9: inherited shared attributes with not null constraints';
-- the constraints of inherited shared attributes are found again by name, not by id, after the subclass is reinstalled
create table t27837_p (a int, s int shared 0 not null, s2 varchar(10) shared 'x' not null, primary key (a));
create table t27837_c under t27837_p (b int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
select attr_name, attr_type, is_nullable from db_attribute where class_name = 't27837_c' order by attr_name;
insert into t27837_p (a) values (1);
insert into t27837_c (a, b) values (2, 1);
select a, b, s, s2 from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 10: two foreign keys added to the subclass one after the other';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int, b2 int);
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
alter table t27837_c add constraint fk_t27837_c_b2 foreign key (b2) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
insert into t27837_p (a) values (1);
insert into t27837_c (a, b, b2) values (2, 1, 1);
-- expected error: a is the primary key
insert into t27837_c (a, b, b2) values (2, 1, 1);
select a, b, b2 from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 11: foreign key defined in the create statement of the subclass';
create table t27837_p (a int, primary key (a));
create table t27837_c under t27837_p (b int, constraint fk_t27837_c_b foreign key (b) references t27837_p (a));
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
insert into t27837_p (a) values (1);
insert into t27837_c (a, b) values (2, 1);
-- expected error: a is the primary key
insert into t27837_c (a, b) values (2, 1);
select a, b from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;


evaluate 'Case 12: foreign keys that fail to be added - the keys stay on their columns, and a later add works';
create table t27837_p (a int, n int, primary key (a));
create table t27837_c under t27837_p (b int);
insert into t27837_p (a, n) values (1, 10);
insert into t27837_c (a, n, b) values (2, 20, 99);
-- expected error: n of the superclass is not a key
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (n);
-- expected error: the row with b = 99 has no match in the superclass
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
update t27837_c set b = 1;
alter table t27837_c add constraint fk_t27837_c_b foreign key (b) references t27837_p (a);
select index_name, key_attr_name, key_order from db_index_key where class_name = 't27837_c' order by index_name, key_order;
-- expected error: a is the primary key
insert into t27837_c (a, n, b) values (2, 30, 1);
select a, n, b from t27837_c order by a;
drop table t27837_c;
drop table t27837_p;
