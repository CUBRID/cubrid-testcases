drop table if exists foo;
create table foo (id varchar(60), stat varchar(15));
insert into foo values ('line', '1');
insert into foo values ('line', '1');
insert into foo values ('line', '1');
insert into foo values ('line', null);
insert into foo values ('line', null);

set optimization level 257;

select /*+ RECOMPILE */ count(*) cnt, id, stat 
from foo where id > '' group by id, stat order by cnt desc;
create index idx1 on foo (id, stat);
select /*+ RECOMPILE */ count(*) cnt, id, stat 
from foo where id > '' group by id, stat order by cnt desc;
select /*+ RECOMPILE NO_COVERING_IDX */ count(*) cnt, id, stat 
from foo where id > '' group by id, stat order by cnt desc;
drop table foo;

create table foo (id varchar(60), stat int);
insert into foo values ('line', 1);
insert into foo values ('line', 1);
insert into foo values ('line', 1);
insert into foo values ('line', null);
insert into foo values ('line', null);

select /*+ RECOMPILE */ count(*) cnt, id, stat 
from foo where id > '' group by id, stat order by cnt desc;
create index idx1 on foo (id, stat);
select /*+ RECOMPILE */ count(*) cnt, id, stat 
from foo where id > '' group by id, stat order by cnt desc;
drop foo;

drop table if exists tb2;
create table tb2 (id int, stat varchar(10));
insert into tb2 values(1,'1'),(2,2),(2,2),(3,null),(3,null);
create index idx_1 on tb2(id,stat);
select sum(id) cnt, id, stat 
from tb2 where id > 1 group by id, stat order by cnt desc;
drop tb2;
