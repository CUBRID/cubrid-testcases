create table foo(a int);
insert into foo(a) values(1), (2), (3);

create table aoo(c bigint);
insert into aoo values(3), (2);

delete f, a from foo f, aoo a where f.a=a.c;

select * from foo order by a;
select * from aoo order by c;

drop table foo, aoo;
