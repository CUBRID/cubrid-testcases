create table aoo(a int, b bigint);
create table boo(c char(20));

insert into aoo values(1,1), (2,2), (3,3);
insert into boo values('a'), ('b'), ('c');

delete a, b from aoo a, boo b where a.a >1 and b.c='a';

select * from aoo order by a;
select * from boo order by c;

drop table aoo, boo;
