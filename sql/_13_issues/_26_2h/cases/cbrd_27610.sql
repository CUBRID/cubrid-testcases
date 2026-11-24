/**
 *  This test case verifies CBRD-27610: ALTER ... MODIFY/CHANGE without a DEFAULT clause or
 *  an ON UPDATE clause does not check the kept function DEFAULT and ON UPDATE expression
 *  against the new type.
 *
 *  A MODIFY or CHANGE without a DEFAULT clause or an ON UPDATE clause keeps the DEFAULT and
 *  the ON UPDATE expression of the column. Only a literal DEFAULT was checked against the new
 *  type, so a function DEFAULT such as TO_CHAR, UNIX_TIMESTAMP, SYS_GUID or SYS_DATETIME and
 *  an ON UPDATE expression moved to a type that CREATE TABLE refuses for them, and an INSERT
 *  that omits the column failed afterwards. The fix checks the kept expressions the way
 *  CREATE TABLE checks its DEFAULT and ON UPDATE clauses and refuses the ALTER.
 *
 *  Each case prints SHOW CREATE TABLE after the ALTER: a refused ALTER leaves the column as
 *  it was, and an accepted one keeps the DEFAULT and the ON UPDATE expression. A change to
 *  AUTO_INCREMENT drops the DEFAULT, so it has no kept DEFAULT to check. The values
 *  of the DEFAULTs change from run to run, so the cases print only their length, whether
 *  they are set, or their difference from the current year.
 *
 *  Coverage:
 *    Case 1:  MODIFY of a TO_CHAR DEFAULT column fails: to DATE with the format 'YYYY' and
 *             to INT without a format, which gives the default format and not NULL
 *    Case 2:  MODIFY of a UNIX_TIMESTAMP DEFAULT column to SMALLINT fails
 *    Case 3:  MODIFY of a SYS_GUID DEFAULT column to INT fails
 *    Case 4:  MODIFY of a SYS_DATETIME DEFAULT column to VARCHAR fails
 *    Case 5:  MODIFY of an ON UPDATE CURRENT_DATETIME column to VARCHAR fails
 *    Case 6:  CHANGE to a new name and a type that does not take the kept DEFAULT fails
 *    Case 7:  MODIFY with a DEFAULT clause still fails on the kept ON UPDATE expression
 *    Case 8:  MODIFY of DATETIME to TIMESTAMP keeps the DEFAULT and the ON UPDATE expression
 *    Case 9:  MODIFY of a TO_CHAR DEFAULT column to INT keeps the DEFAULT
 *    Case 10: MODIFY with a DEFAULT clause keeps the ON UPDATE expression
 *    Case 11: CHANGE to a new name and a type that takes the kept DEFAULT succeeds
 *    Case 12: CHANGE of the name alone and MODIFY to NOT NULL keep the DEFAULT
 *    Case 13: a literal DEFAULT that the new type does not take fails as before
 *    Case 14: a literal DEFAULT that the new type takes is converted as before
 *    Case 15: MODIFY or CHANGE to AUTO_INCREMENT drops the DEFAULT and succeeds
 *    Case 16: MODIFY with an ON UPDATE clause still fails on the kept DEFAULT
 */

drop table if exists t_tochar, t_tochar_nf, t_unix, t_guid, t_dt, t_upd, t_chg, t_upd_def, t_both, t_year, t_keep, t_ren, t_name, t_lit, t_lit_n, t_inc, t_inc_chg, t_onu;


evaluate 'Case 1: MODIFY of a TO_CHAR DEFAULT column to DATE or INT fails';
create table t_tochar (id int, a varchar(100) default to_char(sys_datetime, 'YYYY'));
alter table t_tochar modify a date;
show create table t_tochar;
insert into t_tochar (id) values (1);
select id, length(a), a - year(sys_date) from t_tochar order by id;
create table t_tochar_nf (id int, a varchar(100) default to_char(sys_datetime));
alter table t_tochar_nf modify a int;
show create table t_tochar_nf;
insert into t_tochar_nf (id) values (1);
select id, a is not null from t_tochar_nf order by id;


evaluate 'Case 2: MODIFY of a UNIX_TIMESTAMP DEFAULT column to SMALLINT fails';
create table t_unix (id int, a bigint default unix_timestamp());
alter table t_unix modify a smallint;
show create table t_unix;
insert into t_unix (id) values (1);
select id, length(a), year(from_unixtime(a)) - year(sys_date) from t_unix order by id;


evaluate 'Case 3: MODIFY of a SYS_GUID DEFAULT column to INT fails';
create table t_guid (id int, a varchar(100) default sys_guid());
alter table t_guid modify a int;
show create table t_guid;
insert into t_guid (id) values (1);
select id, length(a) from t_guid order by id;


evaluate 'Case 4: MODIFY of a SYS_DATETIME DEFAULT column to VARCHAR fails';
create table t_dt (id int, a datetime default sys_datetime);
alter table t_dt modify a varchar(100);
show create table t_dt;
insert into t_dt (id) values (1);
select id, year(a) - year(sys_date) from t_dt order by id;


evaluate 'Case 5: MODIFY of an ON UPDATE CURRENT_DATETIME column to VARCHAR fails';
create table t_upd (id int, x int, a datetime on update current_datetime);
alter table t_upd modify a varchar(100);
show create table t_upd;
insert into t_upd (id, x) values (1, 1);
select id, x, a from t_upd order by id;
update t_upd set x = 2 where id = 1;
select id, x, year(a) - year(sys_date) from t_upd order by id;


evaluate 'Case 6: CHANGE to a new name and a type that does not take the kept DEFAULT fails';
create table t_chg (id int, a varchar(100) default to_char(sys_datetime, 'YYYY'), g varchar(100) default sys_guid(), u datetime on update current_datetime);
alter table t_chg change a b date;
alter table t_chg change g h int;
alter table t_chg change u v varchar(100);
show create table t_chg;
select attr_name, data_type, prec, default_value from db_attribute where class_name = 't_chg' order by def_order;


evaluate 'Case 7: MODIFY with a DEFAULT clause still fails on the kept ON UPDATE expression';
create table t_upd_def (id int, x int, a datetime on update current_datetime);
insert into t_upd_def (id, x) values (1, 1);
update t_upd_def set x = 2 where id = 1;
alter table t_upd_def modify a varchar(100) default 'x';
show create table t_upd_def;
select id, x, year(a) - year(sys_date) from t_upd_def order by id;


evaluate 'Case 8: MODIFY of DATETIME to TIMESTAMP keeps the DEFAULT and the ON UPDATE expression';
create table t_both (id int, x int, a datetime default sys_datetime on update current_datetime);
alter table t_both modify a timestamp;
show create table t_both;
insert into t_both (id, x) values (1, 1);
select id, x, year(a) - year(sys_date) from t_both order by id;
update t_both set a = null where id = 1;
update t_both set x = 2 where id = 1;
select id, x, year(a) - year(sys_date) from t_both order by id;


evaluate 'Case 9: MODIFY of a TO_CHAR DEFAULT column to INT keeps the DEFAULT';
create table t_year (id int, a varchar(100) default to_char(sys_datetime, 'YYYY'));
alter table t_year modify a int;
show create table t_year;
insert into t_year (id) values (1);
select id, a - year(sys_date) from t_year order by id;


evaluate 'Case 10: MODIFY with a DEFAULT clause keeps the ON UPDATE expression';
create table t_keep (id int, x int, a datetime on update current_datetime);
alter table t_keep modify a timestamp default sys_timestamp;
show create table t_keep;
insert into t_keep (id, x) values (1, 1);
select id, x, year(a) - year(sys_date) from t_keep order by id;
update t_keep set a = null where id = 1;
update t_keep set x = 2 where id = 1;
select id, x, year(a) - year(sys_date) from t_keep order by id;


evaluate 'Case 11: CHANGE to a new name and a type that takes the kept DEFAULT succeeds';
create table t_ren (id int, a datetime default sys_datetime);
alter table t_ren change a b timestamp;
show create table t_ren;
insert into t_ren (id) values (1);
select id, year(b) - year(sys_date) from t_ren order by id;


evaluate 'Case 12: CHANGE of the name alone and MODIFY to NOT NULL keep the DEFAULT';
create table t_name (id int, a varchar(100) default to_char(sys_datetime, 'YYYY'), g varchar(100) default sys_guid(), u datetime on update current_datetime);
alter table t_name change a b varchar(100);
alter table t_name modify g varchar(100) not null;
alter table t_name change u v datetime;
show create table t_name;
insert into t_name (id) values (1);
update t_name set id = 2 where id = 1;
select id, b - year(sys_date), length(g), year(v) - year(sys_date) from t_name order by id;


evaluate 'Case 13: a literal DEFAULT that the new type does not take fails as before';
create table t_lit (id int, a varchar(100) default 'abc');
alter table t_lit modify a int;
show create table t_lit;
insert into t_lit (id) values (1);
select id, a from t_lit order by id;


evaluate 'Case 14: a literal DEFAULT that the new type takes is converted as before';
create table t_lit_n (id int, n varchar(100) default '12');
alter table t_lit_n modify n int;
show create table t_lit_n;
insert into t_lit_n (id) values (1);
select id, n from t_lit_n order by id;


evaluate 'Case 15: MODIFY or CHANGE to AUTO_INCREMENT drops the DEFAULT and succeeds';
create table t_inc (id int, a bigint default unix_timestamp());
alter table t_inc modify a smallint auto_increment;
show create table t_inc;
insert into t_inc (id) values (1);
select id, a from t_inc order by id;
create table t_inc_chg (id int, g varchar(100) default sys_guid());
alter table t_inc_chg change g h int auto_increment;
show create table t_inc_chg;
insert into t_inc_chg (id) values (1);
select id, h from t_inc_chg order by id;


evaluate 'Case 16: MODIFY with an ON UPDATE clause still fails on the kept DEFAULT';
create table t_onu (id int, a varchar(100) default to_char(sys_datetime, 'YYYY'));
alter table t_onu modify a datetime on update current_datetime;
show create table t_onu;
insert into t_onu (id) values (1);
select id, length(a), a - year(sys_date) from t_onu order by id;


drop table t_tochar, t_tochar_nf, t_unix, t_guid, t_dt, t_upd, t_chg, t_upd_def, t_both, t_year, t_keep, t_ren, t_name, t_lit, t_lit_n, t_inc, t_inc_chg, t_onu;
