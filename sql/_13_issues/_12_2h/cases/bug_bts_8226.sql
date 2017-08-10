--TEST:  [ErrorEnhance] Error message is not clear when creating a view with invalid column name.

create table aa(a int);
insert into aa values(1), (2), (3);

--create view 
create view v as select aa a from aa;
show create view v;

select * from v;
select a.a from v order by 1;


--create view again
create view v1 as select v a from v;
show create view v1;

select * from v1;
select a.a.a from v1 order by 1;


--create view again
create view v2 as select v1 a from v1;
show create view v2;

select * from v2;
select a.a.a.a from v2 order by 1;


--create view again
create view v3 as select v2 a from v2;
show create view v3;

select * from v3;
select a.a.a.a.a from v3 order by 1;


drop table aa;
drop view v;
drop view v1;
drop view v2;
drop view v3;


