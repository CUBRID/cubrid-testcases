drop table if exists t;
create table t(i int);
insert into t values(-1),(-2),(-3);
WITH cte AS
(
select if(1, _utf8'a', _binary'b'), charset(if(1, _utf8'a', _binary'b'))
)
update t set i=(select count(*) from cte);
select * from t order by 1;


WITH cte AS
(
select if(1, _utf8'a', _binary'b'), charset(if(1, _utf8'a', _binary'b')) as col1
)
delete from t where  i=(select count(col1) from cte) limit 2;
select * from t order by 1;

alter table t change column i i int unique;

replace into t
WITH cte AS
(
select if(1, _utf8'a', _binary'b'), charset(if(1, _utf8'a', _binary'b'))
)
select count(*) from cte;
select * from t order by 1;

insert into t
WITH cte AS
(
select if(1, _utf8'a', _binary'b') as col1, charset(if(1, _utf8'a', _binary'b')) as col2
)
select col1 from cte;
select * from t order by 1;

insert into t
WITH cte AS
(
select if(2, _utf8'2', _binary'1') as col1, charset(if(2, _utf8'2', _binary'1')) as col2
)
select col1 from cte;
select * from t order by 1;


drop table if exists t;


