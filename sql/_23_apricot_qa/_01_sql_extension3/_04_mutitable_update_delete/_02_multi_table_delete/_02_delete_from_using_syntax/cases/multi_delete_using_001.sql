--delete from 2 unrelated tables



create table a(a int, b bigint);
create table b(c char(20));

insert into a values(1,1), (2,2), (3,3);
insert into b values('a'), ('b'), ('c');

select * from a order by 1;
select * from b order by 1;

--TEST:
delete from a, b using a, b where a.a >1 and b.c='a';

select * from a order by 1;
select * from b order by 1;


insert into a values(1,1), (2,2), (3,3);

--TEST: 
delete from a1, a2 using a a1, b a2 where a1.a >1 and a2.c='a';

select * from a order by 1;
select * from b order by 1;



drop table a, b;






