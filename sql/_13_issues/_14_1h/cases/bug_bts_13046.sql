drop table if exists t1;
create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', '01/01/2012'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (6, 'Friday'), (7, 7), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where e1 = 10 order by 1; 
drop t1;

create table t1(i int, e1 int );
insert into t1 values (1, 1), (3, 3), (2,1), (6, 5), (7, 7), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where e1 = 10 order by 1; 
drop t1;

create table t1(i int, e1 int );
insert into t1 values (1, 1), (3, 3), (2,1), (6, 5), (7, 7), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where e1 = 5 order by 1; 
drop t1;

create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', '01/01/2012'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (6, 'Friday'), (7, 7), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where e1 = 'Monday' order by 1; 
drop t1;

create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', '01/01/2012'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (6, 'Friday'), (7,'Monday'), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on  t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where i<7 and e1 = 'Monday' order by 1; 
drop t1;

create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', '01/01/2012'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (2, 'Friday'), (7,'Monday'), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(i,e1);
update statistics on t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where i<7 and e1 = 'Monday' order by 1; 
select /*+ recompile */ i, e1 from t1 where i<7 and e1 = 'Monday' order by 1;
select /*+ recompile */ e1 from t1 where i=2 and e1 < 6 order by 1; 
select /*+ recompile */ i,e1 from t1 where i=2 and e1 < 6 order by 1;
select /*+ recompile */ e1 from t1 where i=2 and e1 = 'Friday' order by 1; 
select /*+ recompile */ i,e1 from t1 where i = 2 and e1 = 'Friday' order by 1;
drop t1;

create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', '01/01/2012'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (2, 'Friday'), (7,'Monday'), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on t1;
set optimization level 513;
select /*+ recompile */ e1 from t1 where  e1 < 10 order by 1; 
drop t1;

drop if exists a;
create table t1(i int, e1 datetime );
insert into t1  values (1,'11/01/2014'), (3,'11/02/2014'), (2,'11/03/2014'), (2,'11/04/2014'), (7,'11/09/2014'), (4,'11/05/2014'), (5,'11/06/2014'), (8,'11/08/2014');
create table a (j int,k datetime);
insert into a select * from t1;
create index idx1 on t1(e1);
update statistics on t1;
set optimization level 513;

select /*+ recompile */ e1 from t1 where  e1 in (select k from a order by k limit 1) order by 1; 
select /*+ recompile */ e1 from t1 where  e1 < (select k from a order by k  desc limit 1) order by 1; 
select /*+ recompile */ e1 from t1 where  e1='11/08/2014' order by 1; 
drop t1,a;
