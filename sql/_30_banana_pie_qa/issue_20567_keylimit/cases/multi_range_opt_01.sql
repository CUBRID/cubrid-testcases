--Multiple Key Ranges Optimization
drop if exists student;
create table  student(id int auto_increment,s_class varchar(5),score int);
insert into student(s_class,score)
values('1',85),('1',87),('1',90),('1',93),('1',98),('1',72),('1',65);
insert into student(s_class,score) values('2',80),('2',84),('2',90),('2',95),('2',96),('2',70),('2',86);
insert into student(s_class,score) values('3',91),('3',81),('3',71),('3',61),('3',51),('3',41),('3',31);
insert into student(s_class,score) values('4',93),('4',93),('4',93),('4',93),('4',93),('4',93),('4',93);
create index i_s_23 on student(s_class,score);
update statistics on student;
set optimization level=513;
set system parameters 'multi_range_optimization_limit=10000';
select /*+ recompile */ id,score from student where s_class in ('1','3') and score>=90 order by score desc limit 0,10*10; 
select /*+ recompile */ id,score from student where s_class in ('1','3') and score>=90 order by score desc limit 0,10*10*10;
select /*+ recompile */ id,score from student where s_class in ('1','3') and score>=90 order by score desc limit 1,10*10*10;

select /*+ recompile */ id,score from (select * from student order by 1,2,3) group by s_class having score>=90 order by score desc limit 0*8,0+1;
select /*+ recompile */ id,score from student where s_class in ('1','2') and score>=90 order by score limit 0*5,4+0;
select /*+ recompile */ id,score from student where s_class in ('1','3') and score>=90 order by score desc limit 4-4,2+3;
select /*+ recompile */ id,score from (select * from student order by 1,2,3) where score>=90 order by score limit 0*1,4*1;
set system parameters 'multi_range_optimization_limit=100';
drop student;
