/**
 *  This test case verifies CBRD-28042: ALTER TABLE ADD COLUMN on a class that has
 *  subclasses skips the NOT NULL check and the fill of an expression DEFAULT when
 *  only the leaf classes are empty.
 *
 *  ADD COLUMN asks whether the class has rows before it rejects a NOT NULL column
 *  that has no DEFAULT and before it fills the existing rows with an expression
 *  DEFAULT. For a class with subclasses the check looked only at the subclasses,
 *  so the rows of a superclass or of a middle class were not seen when the leaf
 *  classes were empty. The fix looks at the heap of the class itself first and
 *  then at its subclasses.
 *
 *  SYS_DATETIME and SYS_GUID() values change from run to run, so the cases print
 *  only how many rows have a value and how many distinct values there are.
 *  FROM ALL reads the whole hierarchy and FROM ONLY reads one class.
 *
 *  Coverage:
 *    Case 1:  NOT NULL without DEFAULT fails when the class has rows and an empty subclass
 *    Case 2:  DEFAULT SYS_DATETIME fills the rows of a class that has an empty subclass
 *    Case 3:  NOT NULL DEFAULT SYS_GUID() gives each row of the class its own value
 *    Case 4:  DEFAULT SYS_DATETIME fills the rows of the root and the middle class above an empty leaf
 *    Case 5:  NOT NULL without DEFAULT fails when only the middle class has rows
 *    Case 6:  with two superclasses only the one that has rows rejects NOT NULL
 *    Case 7:  add_column_update_hard_default fills the rows of a class that has an empty subclass
 *    Case 8:  a class without subclasses rejects NOT NULL and fills DEFAULT SYS_DATETIME as before
 *    Case 9:  rows in the subclass too are all filled as before
 *    Case 10: rows only in the leaf class reject NOT NULL as before
 *    Case 11: an empty hierarchy accepts NOT NULL as before
 *    Case 12: a hierarchy whose rows were all deleted accepts NOT NULL as before
 *    Case 13: a partitioned table with rows rejects NOT NULL and fills DEFAULT SYS_DATETIME as before
 */

drop table if exists t_leaf_b, t_mid_b, t_root_b, t_leaf_c, t_mid_c, t_root_c, t_leaf_j, t_mid_j, t_root_j;
drop table if exists t_sub_a, t_sup_a, t_sub_d, t_sup_d, t_sub_g, t_sup_g, t_sub_m, t_sup_m, t_sup_n, t_sub_h, t_sup_h;
drop table if exists t_sub_r, t_sup_r, t_leaf_e, t_mid_e, t_root_e, t_sub_x, t_sup_x, t_solo, t_part;


evaluate 'Case 1: NOT NULL without DEFAULT fails when the class has rows and an empty subclass; an error is expected';
create table t_sup_a (a int);
create table t_sub_a under t_sup_a;
insert into t_sup_a values (1), (2);
alter table t_sup_a add column n int not null;
select class_name, attr_name from db_attribute where class_name in ('t_sup_a', 't_sub_a') order by class_name, attr_name;
select * from all t_sup_a order by a;


evaluate 'Case 2: DEFAULT SYS_DATETIME fills the rows of a class that has an empty subclass';
create table t_sup_d (a int);
create table t_sub_d under t_sup_d;
insert into t_sup_d values (1), (2);
alter table t_sup_d add column d datetime default sys_datetime;
select a, if (d is null, 'null', 'filled') from t_sup_d order by a;
select count(*), count(d), count(distinct d) from t_sup_d;
insert into t_sub_d (a) values (3);
select count(*), count(d) from all t_sup_d;


evaluate 'Case 3: NOT NULL DEFAULT SYS_GUID() gives each row of the class its own value';
create table t_sup_g (a int);
create table t_sub_g under t_sup_g;
insert into t_sup_g values (1), (2), (3);
alter table t_sup_g add column g varchar(40) not null default sys_guid();
select a, if (g is null, 'null', 'filled'), length (g) from t_sup_g order by a;
select count(*), count(g), count(distinct g) from t_sup_g;


evaluate 'Case 4: DEFAULT SYS_DATETIME fills the rows of the root and the middle class above an empty leaf';
create table t_root_b (a int);
create table t_mid_b under t_root_b;
create table t_leaf_b under t_mid_b;
insert into t_root_b values (1), (2);
insert into t_mid_b values (3);
alter table t_root_b add column d datetime default sys_datetime;
select count(*), count(d) from only t_root_b;
select count(*), count(d) from only t_mid_b;
select count(*), count(d), count(distinct d) from all t_root_b;


evaluate 'Case 5: NOT NULL without DEFAULT fails when only the middle class has rows; two errors are expected';
create table t_root_c (a int);
create table t_mid_c under t_root_c;
create table t_leaf_c under t_mid_c;
insert into t_mid_c values (1), (2);
alter table t_root_c add column n int not null;
alter table t_mid_c add column m int not null;
select class_name, attr_name from db_attribute where class_name in ('t_root_c', 't_mid_c', 't_leaf_c') order by class_name, attr_name;


evaluate 'Case 6: with two superclasses only the one that has rows rejects NOT NULL; one error is expected';
create table t_sup_m (a int);
create table t_sup_n (b int);
create table t_sub_m under t_sup_m, t_sup_n;
insert into t_sup_m values (1);
alter table t_sup_m add column n int not null;
alter table t_sup_n add column k int not null;
select class_name, attr_name from db_attribute where class_name in ('t_sup_m', 't_sup_n', 't_sub_m') order by class_name, attr_name;


evaluate 'Case 7: add_column_update_hard_default fills the rows of a class that has an empty subclass';
create table t_sup_h (a int);
create table t_sub_h under t_sup_h;
insert into t_sup_h values (1), (2);
set system parameters 'add_column_update_hard_default=yes';
alter table t_sup_h add column n int not null;
set system parameters 'add_column_update_hard_default=default';
select a, n from t_sup_h order by a;


evaluate 'Case 8: a class without subclasses rejects NOT NULL and fills DEFAULT SYS_DATETIME as before; one error is expected';
create table t_solo (a int);
insert into t_solo values (1), (2);
alter table t_solo add column n int not null;
alter table t_solo add column d datetime default sys_datetime;
select attr_name from db_attribute where class_name = 't_solo' order by attr_name;
select count(*), count(d), count(distinct d) from t_solo;


evaluate 'Case 9: rows in the subclass too are all filled as before';
create table t_sup_r (a int);
create table t_sub_r under t_sup_r;
insert into t_sup_r values (1), (2);
insert into t_sub_r values (3);
alter table t_sup_r add column g varchar(40) not null default sys_guid();
select count(*), count(g), count(distinct g) from only t_sup_r;
select count(*), count(g), count(distinct g) from all t_sup_r;


evaluate 'Case 10: rows only in the leaf class reject NOT NULL as before; an error is expected';
create table t_root_j (a int);
create table t_mid_j under t_root_j;
create table t_leaf_j under t_mid_j;
insert into t_leaf_j values (1);
alter table t_root_j add column n int not null;
select count(*) from db_attribute where class_name in ('t_root_j', 't_mid_j', 't_leaf_j') and attr_name = 'n';


evaluate 'Case 11: an empty hierarchy accepts NOT NULL as before';
create table t_root_e (a int);
create table t_mid_e under t_root_e;
create table t_leaf_e under t_mid_e;
alter table t_root_e add column n int not null;
alter table t_root_e add column d datetime default sys_datetime;
insert into t_root_e (a, n) values (1, 10);
insert into t_leaf_e (a, n) values (2, 20);
select a, n, if (d is null, 'null', 'filled') from all t_root_e order by a;


evaluate 'Case 12: a hierarchy whose rows were all deleted accepts NOT NULL as before';
create table t_sup_x (a int);
create table t_sub_x under t_sup_x;
insert into t_sup_x values (1), (2);
delete from t_sup_x;
alter table t_sup_x add column n int not null;
select class_name, attr_name, is_nullable from db_attribute where class_name in ('t_sup_x', 't_sub_x') and attr_name = 'n' order by class_name;


evaluate 'Case 13: a partitioned table with rows rejects NOT NULL and fills DEFAULT SYS_DATETIME as before; one error is expected';
create table t_part (a int) partition by range (a) (partition p_low values less than (10), partition p_high values less than maxvalue);
insert into t_part values (1), (20);
alter table t_part add column n int not null;
alter table t_part add column d datetime not null default sys_datetime;
select attr_name from db_attribute where class_name = 't_part' order by attr_name;
select count(*), count(d), count(distinct d) from t_part;


drop table t_leaf_b, t_mid_b, t_root_b, t_leaf_c, t_mid_c, t_root_c, t_leaf_j, t_mid_j, t_root_j;
drop table t_sub_a, t_sup_a, t_sub_d, t_sup_d, t_sub_g, t_sup_g, t_sub_m, t_sup_m, t_sup_n, t_sub_h, t_sup_h;
drop table t_sub_r, t_sup_r, t_leaf_e, t_mid_e, t_root_e, t_sub_x, t_sup_x, t_solo, t_part;
