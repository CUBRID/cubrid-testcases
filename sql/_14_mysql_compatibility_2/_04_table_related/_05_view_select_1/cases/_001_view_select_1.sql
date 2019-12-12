-- test creating views from selects without a table
-- like "select 1";

create view w as select 1 as unu, 2 as doi;
select * from w;


alter view w as select sqrt(2) as root;
select * from w;

alter view w as select 23 as d union select sqrt(100);
select * from w order by d;

alter view w as select (select 2) as d, 3 as t;
select * from w;


create view ww as select * from w union select 10, 20;
select * from ww order by d;



create table t (i int);
insert into t values (99);


create view w1 as select (select 2 from t where 3 = charset) as col from db_root;
select * from w1;
drop view w1;

-- it should complain that charset is unknown
create view w1 as select (select 2 from t where 3 = charset) as col;
drop table t;



drop view w;
drop view ww;
