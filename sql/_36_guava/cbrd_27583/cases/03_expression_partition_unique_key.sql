/**
 *  This test case verifies CBRD-27583: a unique key lookup on a table partitioned by an
 *  expression, as in range (year (d)) or hash (k + 1), picks the partition by the value of
 *  the partition expression, as row routing does.
 *
 *  The lookup is the one of INSERT ON DUPLICATE KEY UPDATE, REPLACE and the foreign key check.
 *  Before the change it picked the partition by the attribute's value, so it searched another
 *  partition: an existing key failed ON DUPLICATE KEY UPDATE and REPLACE with a unique
 *  constraint violation, and a child row referring to an existing key failed the foreign key.
 *  A key that no partition holds was searched in the first partition, and adding a foreign
 *  key to such a table stopped the server (the first ALTER of Case 6 already).
 *  Now the lookup updates, replaces and accepts the child row (specification change 24), and a
 *  key no partition holds is a key that does not exist (CBRD-27692): adding the foreign key
 *  reports it invalid.
 *
 *  Judged by the literal results: the rows after each statement, and the foreign key errors of
 *  the keys that do not exist.
 *
 *  Coverage:
 *    Case 1:  range (year (d)), ON DUPLICATE KEY UPDATE, REPLACE and a duplicate INSERT
 *    Case 2:  a foreign key referring to the range (year (d)) table
 *    Case 3:  hash (k + 1) and list (k mod 3)
 *    Case 4:  keys out of every range of the expression and of the column itself
 *    Case 5:  the column itself as the partition key, as before
 *    Case 6:  ALTER TABLE ADD FOREIGN KEY over child keys inside and outside the partitions
 */

drop table if exists t_late_year, t_late_col, t_child_year, t_child_col, t_year, t_hash, t_list, t_col;

-- each table holds one key per partition, so a lookup in the wrong partition misses it
create table t_year (d date primary key, v int) partition by range (year (d)) (partition p_old values less than (2000), partition p_new values less than (2030));
insert into t_year values (date'1990-01-01', 1), (date'2020-01-01', 2);
create table t_hash (k int primary key, v int) partition by hash (k + 1) partitions 4;
insert into t_hash values (1, 1), (2, 2), (3, 3), (4, 4);
create table t_list (k int primary key, v int) partition by list (k mod 3) (partition p_zero values in (0), partition p_one values in (1), partition p_two values in (2));
insert into t_list values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);
create table t_col (d date primary key, v int) partition by range (d) (partition p_old values less than (date'2000-01-01'), partition p_new values less than (date'2030-01-01'));
insert into t_col values (date'1990-01-01', 1), (date'2020-01-01', 2);


evaluate 'Case 1: range (year (d)), ON DUPLICATE KEY UPDATE, REPLACE and a duplicate INSERT';
insert into t_year values (date'2020-01-01', 3) on duplicate key update v = 30;
insert into t_year values (date'1990-01-01', 4) on duplicate key update v = 40;
replace into t_year values (date'2020-01-01', 5);
insert into t_year values (date'2020-01-01', 6);
select * from t_year order by d;


evaluate 'Case 2: a foreign key referring to the range (year (d)) table';
create table t_child_year (id int primary key, d date, foreign key (d) references t_year (d));
insert into t_child_year values (1, date'2020-01-01');
insert into t_child_year values (2, date'1990-01-01');
insert into t_child_year values (3, date'2021-01-01');
update t_child_year set d = date'1990-01-01' where id = 1;
select * from t_child_year order by id;


evaluate 'Case 3: hash (k + 1) and list (k mod 3)';
insert into t_hash values (3, 30) on duplicate key update v = 300;
insert into t_hash select 4, 40 from db_root on duplicate key update v = 400;
replace into t_hash values (2, 20);
insert into t_hash values (3, 31);
select * from t_hash order by k;
insert into t_list values (2, 20) on duplicate key update v = 200;
insert into t_list values (4, 40) on duplicate key update v = 400;
insert into t_list values (5, 50) on duplicate key update v = 500;
insert into t_list values (6, 61);
select * from t_list order by k;


evaluate 'Case 4: keys out of every range of the expression and of the column itself';
insert into t_year values (date'2050-01-01', 7) on duplicate key update v = 70;
replace into t_year values (date'2050-01-01', 8);
insert into t_col values (date'2050-01-01', 7) on duplicate key update v = 70;
replace into t_col values (date'2050-01-01', 8);
select * from t_year order by d;
select * from t_col order by d;
insert into t_child_year values (4, date'2050-01-01');
select * from t_child_year order by id;


evaluate 'Case 5: the column itself as the partition key, as before';
insert into t_col values (date'2020-01-01', 3) on duplicate key update v = 30;
replace into t_col values (date'1990-01-01', 5);
create table t_child_col (id int primary key, d date, foreign key (d) references t_col (d));
insert into t_child_col values (1, date'2020-01-01');
insert into t_child_col values (2, date'2021-01-01');
select * from t_col order by d;
select * from t_child_col order by id;



evaluate 'Case 6: ALTER TABLE ADD FOREIGN KEY over child keys inside and outside the partitions';
create table t_late_year (id int primary key, d date);
insert into t_late_year values (1, date'1990-01-01'), (2, date'2020-01-01');
alter table t_late_year add constraint fk_late_year foreign key (d) references t_year (d);
create table t_late_col (id int primary key, d date);
insert into t_late_col values (1, date'1990-01-01'), (2, date'2050-01-01');
alter table t_late_col add constraint fk_late_col foreign key (d) references t_col (d);
select class_name, index_name from db_index where class_name in ('t_late_year', 't_late_col') and is_foreign_key = 'YES' order by 1;

drop table t_late_year, t_late_col;
drop table t_child_year, t_child_col, t_year, t_hash, t_list, t_col;
