--TEST:  [Pseudocolumn in DEFAULT clause] INSERT INTO view with DEFAULT value doesn't work well.


drop table if exists t1;
create table t1(
	a timestamp default CURRENT_TIMESTAMP,
	b timestamp default SYSTIMESTAMP,
	c timestamp default UNIX_TIMESTAMP(),
	d date default SYSDATE,
	e datetime default SYSDATETIME,
	f string default USER,
	g string default CURRENT_USER
);


create view v as select * from t1;

show columns in v;

drop view v;
drop table t1;
