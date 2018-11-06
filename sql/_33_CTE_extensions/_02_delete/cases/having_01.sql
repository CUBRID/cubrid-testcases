drop if exists student;

create table  student(id int auto_increment,s_class varchar(5),score double);

insert into student(s_class,score)
values('1',85.5),('1',87.5),('1',90.5),('1',93),('1',98),('1',72),('1',65);

insert into student(s_class,score) values('2',80),('2',84),('2',90),('2',95),('2',96),('2',70),('2',86.5);

insert into student(s_class,score) values('3',91),('3',81),('3',71),('3',61),('3',51),('3',41),('3',31);

insert into student(s_class,score) values('4',93),('4',93),('4',93),('4',93),('4',93),('4',93),('4',93);

create index i_s_23 on student(s_class,score);

update statistics on student;

set optimization level 513;
WITH mycte AS
(
select /*+ recompile */ s_class,id,min(score) as min_score 
from student 
group by s_class having s_class>=3 order by score desc,id limit 0,2
)
delete student from student,mycte where student.score-mycte.min_score=0
and student.s_class=mycte.s_class;

select s_class,cast(score as numeric(3,1)) from student;


drop if exists student;

create table  student(id int auto_increment,s_class varchar(5),score double);

insert into student(s_class,score)
values('1',85.5),('1',87.5),('1',90.5),('1',93),('1',98),('1',72),('1',65);

insert into student(s_class,score) values('2',80),('2',84),('2',90),('2',95),('2',96),('2',70),('2',86.5);

insert into student(s_class,score) values('3',91),('3',81),('3',71),('3',61),('3',51),('3',41),('3',31);

insert into student(s_class,score) values('4',93),('4',93),('4',93),('4',93),('4',93),('4',93),('4',93);

create index i_s_23 on student(s_class,score);

update statistics on student;

set optimization level 513;
WITH mycte AS
(
select /*+ recompile */ s_class,id,avg(score) as min_score
from student
group by s_class having s_class>=3 order by score desc,id limit 0,2
)
delete student from  student,mycte where student.score-mycte.min_score=0
and student.s_class=mycte.s_class;

select s_class,cast(score as numeric(3,1)) from student;
