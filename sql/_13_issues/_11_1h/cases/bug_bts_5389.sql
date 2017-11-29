create table foo(c int, p int);

insert into foo values (1,null);
insert into foo values (2,1);
insert into foo values (3,1);
insert into foo values (4,2);

select (select count(c) from foo f where f.p=f1.c) a, c,p
from foo f1
start with c=1
connect by prior c=p order by 1,2,3;

drop table foo;
