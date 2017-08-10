drop table if exists z1;

create table z1 (a int, b int);

insert into z1 values (1,1);
insert into z1 values (1,2);
insert into z1 values (2,1);

--test: we expect below query will be successful. In fact, oracle gives successful result.
select /*+ recompile */ a,b, ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 order by 1;

select /*+ recompile */  ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 order by 1;

select /*+ recompile */  ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11, ROW_NUMBER() over(PARTITION BY a ORDER BY a desc), ROW_NUMBER() over(PARTITION BY a ORDER BY a desc), ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 order by 1;

select /*+ recompile */  ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 as x1 order by 1;

select /*+ recompile */ distinct ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 as x1 order by 1;

select * from(select /*+ recompile */ distinct ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 as x1) order by 1;


drop table  z1;
create table z1 (a varchar(10), b char(20));
insert into z1 values ('','');
insert into z1 values ('1','2');
insert into z1 values ('2','1');
insert into z1 values ('2','1');

--test: we expect below query will be successful. In fact, oracle gives successful result.
select /*+ recompile */ a,b, ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 order by 1;

select /*+ recompile */  ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1  order by 1;

select /*+ recompile */  ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11, ROW_NUMBER() over(PARTITION BY a ORDER BY a desc), ROW_NUMBER() over(PARTITION BY a ORDER BY a desc), ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 order by 1;

select /*+ recompile */  ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 as x1 order by 1;

select /*+ recompile */ distinct ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 as x1 order by 1;

select * from(select /*+ recompile */ distinct ROW_NUMBER() over(PARTITION BY a ORDER BY a desc) c11 from z1 as x1) order by 1;

drop table  z1;