drop table if exists tb1, tb2;
create table tb1(a int, b varchar(10));
create table tb2(a int, b varchar(10));
insert into tb1 values(1,'aa'),(2,'bb');
insert into tb2 values(1,'cc'),(2,'dd');
select a,b,(select b from tb1 aa where tb1.a=aa.a union all select b from tb2 bb where tb1.a=bb.a limit 1) c from tb1;
select a,b,(select b from tb1 aa where tb1.a=aa.a union all select b from tb2 bb where tb1.a=bb.a order by 1 desc limit 1) c from tb1;
select a,b, (select b from tb1 aa union all select b from tb2 limit 1) c from tb1;
drop table tb1, tb2;
