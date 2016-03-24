create table foo (a int, b int);

insert into foo values (1,1);
insert into foo values (2,2);
insert into foo values (1,3);

select /*+ recompile */ a from foo group by a;

select /*+ recompile */ a from foo where a=4 group by a;

select /*+ recompile */ a from foo where 1=0 group by a;

drop table foo;
