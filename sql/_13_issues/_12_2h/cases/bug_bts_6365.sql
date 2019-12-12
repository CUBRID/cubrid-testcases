drop table if exists t;

create table t (a int, b int);
create index idxa on t(a);

insert into t values (1,2), (2,3), (3,4), (4,5), (5,6);

select * from t
	start with a = 1
	connect by prior b = a;
select * from t
	where rownum = 1
	start with a = 1
	connect by prior b = a;
select * from t
	where rownum = 1
	start with a = 1
	connect by prior b = a
	using index none;
	
drop table if exists t;
