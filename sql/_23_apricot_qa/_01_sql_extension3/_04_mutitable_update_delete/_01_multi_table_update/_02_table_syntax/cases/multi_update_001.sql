--update 2 unrelated tables



create table a(a int, b bigint);
create table b(b char(20));

insert into a values(1,1), (2,2), (3,3);
insert into b values('a'), ('b'), ('c');

select * from a order by 1, 2;
select * from b order by 1;


--TEST: update 2 unrelated tables
update a, b set a.a=100, b.b='abc' where a.a >1 and b.b='a';

--TEST: check update results
select * from a order by 1, 2;
select * from b order by 1;


insert into a values(1,1), (2,2), (3,3);

--TEST: update 2 unrelated tables
update a a1, b a2 set a1.a=200, a1.b=300, a2.b='cba' where a1.a >1 and a2.b='b';

--TEST: check update results
select * from a order by 1, 2;
select * from b order by 1;



drop table a, b;






