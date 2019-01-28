drop if exists tb1,tb2,foo,t1;
create class tb1 ( a set(char(2)));
create class tb2 ( b set(nchar(2)));
insert into tb1 values({'a1'});
insert into tb2 values({n'a1'});
select a,b from tb1, tb2 where a seteq b order by 1,2;
create table cte as WITH cte AS
(
select a,b from tb1, tb2 where a setneq b order by 1,2
)
select * from cte;
select * from foo;
drop if exists tb1,tb2,foo,t1;
