--CLIENT
create class c(i int);

insert into c values (1), (2), (3), (4), (5);

create vclass v1(ai) as select * from c where i < 5;
create vclass v2(ai) as select * from c where i > 1;

delete v1 from c, v1, v2 where c.i=v1.ai and v1.ai=v2.ai and c.i=3;
select * from c order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

delete v1, v2 from c, v1, v2 where c.i=v1.ai and v1.ai=v2.ai and v1.ai=2;
select * from c order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

delete v1, v2, c from c, v1, v2 where c.i=v1.ai and v1.ai=v2.ai and v1.ai=4;
select * from c order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

drop class c;
drop vclass v1;
drop vclass v2;