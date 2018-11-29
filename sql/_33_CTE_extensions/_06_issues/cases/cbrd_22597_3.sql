drop table if exists t1,foo;

create table t1(e enum('a', 'b', 'c', 'xyz'));

insert into t1 values (1), ('b'), (3), ('xyz');

create table foo as
with cte(c) as
(
select group_concat(e order by e asc) from t1
) select * from cte;


replace into foo
with cte(c,d) as
(
    select e, case e when 1 then 10 when 2 then e when 3 then e else e end from t1 order by 1, 2
)select d from cte ;

replace into foo
with cte(c,d) as
(
    select e, case when cast(e as int)=1 then 10 when  cast(e as int)=2 then e when  cast(e as int)=3 then e else e end from t1 order by 1, 2
) select d from cte ;


with cte(c,d) as
(
    select e, case e when 1 then 10 when 2 then e when 3 then e else e end from t1 order by 1, 2
)select d from cte ;

with cte(c,d) as
(
    select e, case when cast(e as int)=1 then 10 when  cast(e as int)=2 then e when  cast(e as int)=3 then e else e end from t1 order by 1, 2
) select d from cte ;

with cte(c,d) as
(
select least(e, e, e, 2), least(e, e, e, 'x') from t1 order by 1, 2
)select c from cte ;


with cte(c) as
(
select least(e, e, e, cast(e as int)) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c,d) as
(
select greatest(e, e, e, 2), greatest(e, e, e, 'x') from t1 order by 1, 2
)select c from cte ;



with cte(c) as
(
select greatest(e, e, e, cast(e as int)) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

drop table if exists  foo,t1;
