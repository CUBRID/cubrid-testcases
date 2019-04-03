drop if exists student;
create table  student(id int auto_increment,s_class varchar(5),score double);
insert into student(s_class,score)
values('1',85.5),('1',87.5),('1',90.5),('1',93),('1',98),('1',72),('1',65);
insert into student(s_class,score) values('2',80),('2',84),('2',90),('2',95),('2',96),('2',70),('2',86.5);
insert into student(s_class,score) values('3',91),('3',81),('3',71),('3',61),('3',51),('3',41),('3',31);
insert into student(s_class,score) values('4',93),('4',93),('4',93),('4',93),('4',93),('4',93),('4',93);
create index i_s_23 on student(s_class,score);
update statistics on student;
select /*+ recompile */ min(id),min(score) from student group by s_class having s_class>=3 order by score desc,id limit 0,1;
select /*+ recompile */ id,score from student where s_class in ('1','2') and score>=90 order by score,id limit 0,4;
select /*+ recompile */ id,score from student where s_class in ('1','2') and score>=90 order by score desc,id limit 0,4;
select /*+ recompile */ id,score from student where s_class in ('1','3') and score>=90 order by score desc,id limit 0,4;
select /*+ recompile */ id,score from student where s_class in ('1','3') and score>=90 order by score,id limit 0,4;
select /*+ recompile */ id,score from student where s_class in ('1','2','3','4') and score>=90 order by score,id limit 0,4;
select /*+ recompile */ id,score from student where score>=90 order by score,id limit 0,4;
drop student;

drop if exists tt;
create table tt(a int, b int);
insert into tt values(1,1),(1,2),(1,3),(1,4),(1,5),(2,1),(2,2),(2,3),(2,4),(2,5);
create index i_ab on tt(a,b);
update statistics on tt with fullscan;
select/*+ recompile */ * from tt where a in (1,2) order by b limit 0,3;
drop tt;

drop  if exists t;
create table t (i1 int, i2 int, i3 int);

create index i_t_123 on t(i1, i2, i3);
create index i_t_123_desc on t(i1, i2 desc, i3);
create index i_t_12 on t(i1, i2);
create index i_t_12_desc on t(i1, i2 desc);

insert into t values (0, 0, 00), (0, 1, 01), (0, 2, 02), (0, 3, 03), (0, 4, 04);

insert into t values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);

insert into t values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);

insert into t values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);

insert into t values (4, 0, 40), (4, 1, 41), (4, 2, 42), (4, 3, 43), (4, 4, 44);
update statistics on all classes;
select /*+ recompile */ * from t where i1 between 2 and 4 order by i2 desc limit 0,2;
select /*+ recompile */ * from t where i1 between 2 and 4 order by i2  limit 0,2;

select /*+ recompile */ * from t where i1=1 order by i2  limit 0,2;
select /*+ recompile */ * from t where i1 in(0,1)  limit 0,2;
drop t;

create table t(id int);
create index idx_id on t(id);
insert into t values(5),(2),(1),(7),(3),(6),(4);
update statistics on t with fullscan;
select /*+ recompile */ id from t where id >2 limit 0,3;
drop t;


drop if exists t1,t2;
create table t1(i int,j int,k int);
create table t2(i int,j int);
create index idx on t1(i,j,k);
insert into t1 values (2,1,3),(6,2,5),(4,3,5),(2,0,3);
insert into t2 values (2,3),(2,5), (5,5),(6,6);
select /*+ recompile ordered */ * from t1,t2 where t1.i = t2.i and t1.i=2 and t1.j in (0,1,2,3) order by 1,2,3,4,5 limit 0,5;
drop t1,t2;


