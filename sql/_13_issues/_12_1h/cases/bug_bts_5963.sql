autocommit on;
set system parameters 'no_backslash_escapes=no';
create table t(id int, cc varchar(100));
insert into t values(1,'\'');
insert into t values(2,'"');
insert into t values(3,'\"');
select * from t;
drop table t;

set system parameters 'no_backslash_escapes=yes';
create table t(id int, cc varchar(100));
insert into t values(1,'\'');
insert into t values(2,'"');
insert into t values(3,'\"');
select * from t;
drop table t;



