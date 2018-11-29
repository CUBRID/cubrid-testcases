drop table if exists t;
create table t(i int);
insert into t values(1),(4);

drop table if exists foo;
create table foo(a int );
insert into foo values(2),(3);

insert into foo set a=(with cte as
    (select * from t)
    select i from cte,foo where i<a limit 1
);
select * from foo order by 1;

delete from foo where a=(with cte as
    (select * from t)
    select i from cte,foo where i<a limit 1
);
select * from foo order by 1;

replace into foo set a=(
with cte as
    (select * from t)
        select i from cte,foo where i<a limit 1);
        
select * from foo order by 1;


insert into foo set a=(with cte as
    (select * from t)
    select i from cte order by 1 desc limit 1
);
select * from foo order by 1;


replace into foo set a=(with cte as
    (select * from t)
    select i from cte order by 1 desc limit 1
);
select * from foo order by 1;

drop table if exists foo,t;
