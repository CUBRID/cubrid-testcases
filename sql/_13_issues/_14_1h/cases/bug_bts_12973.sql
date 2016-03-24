drop table if exists foo;
create table foo (a int, b int, c int);
create index idx_a on foo (a desc);
insert into foo values (0, 0, 0);
insert into foo values (1, 1, 1);

set optimization level 513;

select /*+ RECOMPILE */ a from foo where a >= 0 order by a;
select /*+ RECOMPILE */ a from foo where a >= 0 order by a desc;
select /*+ RECOMPILE */ a from foo where a <=1 order by a;
select /*+ RECOMPILE */ a from foo where a <=1 order by a desc;
drop foo;

create table foo (a int, b int);
create index idx_a on foo (a ASC);
insert into foo values (0, 0);
insert into foo values (1, 1);
insert into foo values (3, 3);
insert into foo values (3, 1);
insert into foo values (3, 6);
insert into foo values (5, 5);

set optimization level 513;
select /*+ RECOMPILE */ a from foo where a >= 0 order by a;
select /*+ RECOMPILE */ a from foo where a >3 order by a;
select /*+ RECOMPILE */ a from foo where a >= 0 order by a desc;
select /*+ RECOMPILE */ a from foo where a >3 order by a desc;
select /*+ RECOMPILE */ a from foo where a >= 0 group by a;
select /*+ RECOMPILE */ a from foo where a >= 0 group by a desc;
insert into foo values (6, 7);
select /*+ RECOMPILE */ a from foo where a >3 order by a;
select /*+ RECOMPILE */ a from foo where a >3 order by a desc;

drop foo;

create table foo (a int, b int,c int ,d int);
create index idx_a_b_c_d on foo (a desc,b asc,c asc,d desc);
insert into foo values (0, 0,8,1);
insert into foo values (1, 1,7,5);
insert into foo values (3, 3,6,5);
insert into foo values (3, 1,8,9);
insert into foo values (3, 6,5,6);
insert into foo values (5, 5,2,4);

set optimization level 513;
select /*+ RECOMPILE */ a from foo where a >= 3 order by a;
select /*+ RECOMPILE */ * from foo where a >= 3 order by a;
select /*+ RECOMPILE */ * from foo where a >= 3 order by a,b;
select /*+ RECOMPILE */ * from foo where a >= 3 order by a,b,c;
select /*+ RECOMPILE */ * from foo where a >= 3 order by a,b,c,d;
select /*+ RECOMPILE */ * from foo where a >= 3 order by a,b desc,c desc,d asc;
select /*+ RECOMPILE */ * from foo where a >= 3 order by a desc,b asc,c asc,d desc;

select /*+ RECOMPILE */ a from foo where a >=0 group by a;
select /*+ RECOMPILE */ * from foo where a >=0 group by a;
select /*+ RECOMPILE */ * from foo where a >=0 group by a desc;
select /*+ RECOMPILE */ * from foo where a >=0 group by a,b;
select /*+ RECOMPILE */ * from foo where a >=0 group by a,b,c;
select /*+ RECOMPILE */ * from foo where a >=0 group by a,b,c,d;
select /*+ RECOMPILE */ * from foo where a >=0 group by a,b desc,c desc,d asc;
select /*+ RECOMPILE */ * from foo where a >=0 group by a desc,b asc,c asc,d desc;

drop foo;



