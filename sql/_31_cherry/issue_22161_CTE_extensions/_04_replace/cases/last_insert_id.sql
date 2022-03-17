drop table if exists t,foo;
create table t(i int primary key);
insert into t values(1),(3);

create table foo as
select * from t order by 1;

alter table foo change column i i int primary key auto_increment(0,10);
insert into foo values (null);
insert into foo
with cte as
(
 select i from t where i<=3
) select i+10 from cte;
select * from foo order by 1;

replace into foo
with cte as
(
 select last_insert_id()
) select * from cte;

select * from foo order by 1;


insert into foo
with cte(l) as
(
 select last_insert_id()
) select l+20 from cte;

select * from foo order by 1;



drop table if exists t,foo;
create table t(i int auto_increment primary key);
insert into t values(null),(null);
insert into t values(null),(null);

insert into t set i=(
with cte as
(
 select i from t where i>=10
) select i+10 from cte);
select * from t order by 1;

replace into t
with cte(a) as
(
 select last_insert_id()
) select null from cte;


replace into t
with cte(a) as
(
 select last_insert_id()
) select a from cte;

select * from t order by 1;


with cte(a) as
(
 select last_insert_id()
) delete from t where i=(select a from cte);

select * from t order by 1;


with cte(a) as
(
 select last_insert_id()
) update t set i=i+20 where i<(select a from cte);

select * from t order by 1;

drop table if exists foo,t;
