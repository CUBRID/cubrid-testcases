-- query plan
drop table if exists x;
create table x(a int, b int);

create index a_x_index on x(a desc);
create index b_x_index on x(b desc);

insert into x values(1,1);
insert into x values(2,1);
insert into x values(3,1);
insert into x values(4,1);
insert into x values(5,1);
insert into x values(6,1);
insert into x values(7,1);
insert into x values(8,1);
insert into x values(9,1);
insert into x values(10,1);
insert into x values(11,2);
insert into x values(12,2);
insert into x values(13,2);
insert into x values(14,2);
insert into x values(15,2);
insert into x values(16,2);
insert into x values(17,2);
insert into x values(18,2);

set trace on output text;
--@queryplan
select /*+ recompile */ median(a) from x order by 1; 
select /*+ recompile */ median(b) from x order by 1;
--trace info are not same every time
--show trace;
set trace off;

select /*+ recompile */ median(a) from x order by 1;
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 0;
select /*+ recompile */ median(a) from x order by 1;
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 1;
select /*+ recompile */ median(a) from x order by 1;
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 2;
select /*+ recompile */ median(a) from x order by 1;
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 257;
select /*+ recompile */ median(a) from x order by 1;
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 258;
--@queryplan
select /*+ recompile */ median(a) from x order by 1;
--@queryplan
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 513;
select /*+ recompile */ median(a) from x order by 1;
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 514;
--@queryplan
select /*+ recompile */ median(a) from x order by 1;
--@queryplan
select /*+ recompile */ median(b) from x order by 1;

SET OPTIMIZATION  LEVEL 1;

drop table if exists x;
