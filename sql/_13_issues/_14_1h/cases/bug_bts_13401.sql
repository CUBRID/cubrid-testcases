autocommit off;
drop table if exists foo;

create table foo (a char(10), b char(10), c int, d int);

insert into foo
select 'a', 'a', rownum, rownum
from
db_class x, db_class y, db_class z, db_class w
limit 100000;

create index idx1 on foo (a, b, c, d);
create index idx2 on foo (a, c, b, d);

update statistics on foo;

--@queryplan 
select /*+ recompile */ min(b) from foo where a = 'a' and c = 100 group by a, b;

--@queryplan
select /*+ recompile index_ls */ min(b) from foo where a = 'a' and c = 100 group by a, b using index idx1;

--@queryplan
select /*+ recompile */ a, b from foo where a = 'a' and c between 100 and 101 group by a, b using index idx2;

--@queryplan
select /*+ recompile index_ls */ a, b from foo where a = 'a' and c between 100 and 101 group by a, b using index idx1;

--@queryplan
select /*+ recompile */ distinct a, b from foo where a = 'a' and c = 100;

--@queryplan
select /*+ recompile index_ls */ distinct a, b from foo where a = 'a' and c = 100 using index idx1;


drop table foo;
autocommit on;