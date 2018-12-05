drop table if exists t1, t2, t3,foo;
create table t1(s1 varchar(1000));
insert into t1 values(repeat('a',300));
create table foo as
with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t1
) select * from cte;
describe foo;
 
insert into foo
 with cte(ds,lg) as
(
select disk_size(s1) , length(s1) from t1
) select ds,count(lg) from cte group by ds;
 
replace into foo
 with cte(ds,lg) as
(
select disk_size(s1) , length(s1) from t1
) select ds,count(lg) from cte group by ds;
 
 
select * from t1 order by 1;
alter table t1 change s1 s1 char(300);

with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t1
) delete from foo where ds <=(select ds from cte);
select * from foo order by 1,2;

drop table if exists t2,foo;
create table t2(s1 varchar);
insert into t2 values(repeat('a',300));

create table foo as
with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t2
) select * from cte;

alter table t2 change s1 s1 char(310);

insert into foo
with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t2
) select * from cte;
select * from foo order by 1,2;

alter table t2 change s1 s1 char(200);
alter table foo change ds ds int primary key;
replace into foo
with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t2
) select * from cte;

replace into foo
with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t2
) select * from cte;

select * from foo order by 1,2;
with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t2
)  delete from foo where ds=(select ds from cte);

with cte(ds,lg) as
(
select disk_size(s1), length(s1) from t2
)  update foo set ds=100 where ds<(select ds from cte);
select * from foo order by 1,2;

drop table if exists t1, t2, t3,foo;
