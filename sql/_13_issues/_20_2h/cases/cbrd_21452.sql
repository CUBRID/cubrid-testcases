drop table if exists test1;
drop table if exists test2;

create table test1 (a int);
insert into test1 (a) values (10);

create table test2 (a int);
insert into test2 (a) values (20);

set optimization level 513;

select /*+ RECOMPILE */ * from test1 limit 1 union all select * from test2 limit 1;
select /*+ RECOMPILE */ * from test1 limit 1 intersection all select * from test2 limit 1;
select /*+ RECOMPILE */ * from test1 limit 1 difference all select * from test2 limit 1;

drop table test1;
drop table test2;
