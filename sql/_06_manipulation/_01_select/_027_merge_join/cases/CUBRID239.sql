--server core when running merge join query

create table foo ( a int, b int);

insert into foo values(0,0);
insert into foo values(1,1);
insert into foo values(2,2);

select /*+ USE_MERGE */ y.b 
from foo x, foo y where x.a > 0 and x.a = y.a and x.b =y.a;

select /*+ USE_MERGE */ y.b , z.b
from foo x, foo y, foo z where x.a > 0 and x.a = y.a and x.b =y.a and x.a = z.a and x.b = z.b;

drop foo;