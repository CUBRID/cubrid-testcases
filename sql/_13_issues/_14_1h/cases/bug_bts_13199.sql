drop table if exists sinfo;
drop table if exists sscore;
drop table if exists scourse;
create table sinfo(id bigint auto_increment,name varchar(20),address varchar(100) , telephone char(11)) auto_increment=07010010;
insert into sinfo select null,null,null,null from db_root connect by level<=10000;
insert into sinfo values(07010001,'lindaiyu','ancient mansion of jia','10000000002');
insert into sinfo values(07010003,'jiabaoyu','ancient mansion of jia','10000000004');
insert into sinfo values(07010005,'xuebaocai','ancient mansion of jia','10000000006');
insert into sinfo values(07010007,'shixiangyun','ancient mansion of jia','10000000008');
insert into sinfo values(07010009,'wangxifeng','ancient mansion of jia','10000000010');
insert into sinfo select null,null,null,null from db_root connect by level<=10000;
create index t1_idx on sinfo(id);

create table sscore(id bigint,course_id int  ,score double );
insert into sscore values(07010001,1,89);
insert into sscore values(07010001,2,95);
insert into sscore values(07010001,3,76);
insert into sscore values(07010001,4,60);
insert into sscore values(07010001,5,10);
insert into sscore values(07010003,1,87);
insert into sscore values(07010003,2,93);
insert into sscore values(07010003,3,74);
insert into sscore values(07010003,4,62);
insert into sscore values(07010003,5,20);
insert into sscore values(07010005,1,91);
insert into sscore values(07010005,2,85);
insert into sscore values(07010005,3,72);
insert into sscore values(07010005,4,64);
insert into sscore values(07010005,5,30);
insert into sscore values(07010007,1,null);
insert into sscore values(07010007,2,null);
insert into sscore values(07010007,3,null);
insert into sscore values(07010007,4,null);
insert into sscore values(07010007,5,null);
insert into sscore values(07010009,1,null);
insert into sscore values(07010009,2,null);
insert into sscore values(07010009,3,null);
insert into sscore values(07010009,4,null);
insert into sscore values(07010009,5,null);
insert into sscore  select rownum,null,80 from db_root connect by level<=2000 ;

create index t2_idx on sscore(id,course_id);
create table scourse(course_id int ,course_name varchar(50) default 'language');
insert into scourse values(1,'math');
insert into scourse values(2,'literature');
insert into scourse values(3,'science');
insert into scourse values(4,'physical');
insert into scourse values(5,'chemistry');
insert into scourse  select null ,null from db_root connect by level<=30;
create index t3_idx on scourse(course_id);

update statistics on all classes;

select /*+ recompile ordered use_merge */ t1.*,t2.*,t3.* from sinfo t1,sscore t2,scourse t3 where 1=1 and t1.id=t2.id and t2.course_id=t3.course_id;

select /*+ recompile use_merge */ t1.*,t2.*,t3.* from sinfo t1,sscore t2,scourse t3 where 1=1 and t1.id=t2.id and t2.course_id=t3.course_id and t2.score is not null and t1.id=07010005 ;

select /*+ recompile use_merge*/ t1.id,t1.name,t2.course_id,t2.score,t3.course_name from sinfo t1,sscore t2,scourse t3 where t1.id=t2.id and t2.course_id=t3.course_id and t1.id <07010003 and t2.score>90;

select /*+ recompile ordered use_merge index_ss */ t1.*,t2.*,t3.* from sinfo t1,sscore t2,scourse t3 where t1.id=t2.id and t2.course_id=t3.course_id and t2.course_id<3 order by t1.id;
select /*+ recompile use_merge*/ t1.*,t2.*,t3.* from sinfo t1,sscore t2,scourse t3 where t1.id=t2.id and t2.course_id=t3.course_id and t3.course_name='physical' and t2.score>60 order by t1.id,t2.score,t3.course_name;


select /*+ recompile ordered use_merge*/ t2.course_id,avg(t2.score) avg_score ,t3.course_name from sinfo t1,sscore t2,scourse t3 where t1.id=t2.id and t2.course_id=t3.course_id group by t2.course_id order by 2 desc;

select /*+ recompile ordered use_merge*/ t2.course_id,avg(t2.score) avg_score ,t3.course_name from sinfo t1,sscore t2,scourse t3 where t1.id=t2.id and t2.course_id=t3.course_id group by t2.course_id having avg_score>70 order by 2 desc;

drop sinfo,sscore,scourse;


drop table if exists foo;
drop table if exists bar;

create table foo (i int, j int);
insert into foo values (1, 1);
insert into foo values (2, 1);

create table bar (v varchar(10), i int);
insert into bar values ('one', 1);
insert into bar values ('two', 2);

select /*+ RECOMPILE ordered USE_MERGE */
f.*, b.*
from foo f join bar b on f.i=b.i and f.j=b.i;
drop foo,bar;

drop table if exists foo;
drop table if exists bar;

create table foo (i int, j int, k int);
insert into foo values (1, 1, 10);
insert into foo values (1, 1, 20);
insert into foo values (2, 1, 10);
insert into foo values (2, 1, 20);

create table bar (v char(30), i int, k int);
insert into bar values ('one', 1, 10);
insert into bar values ('one', 1, 20);
insert into bar values ('two', 2, 10);
insert into bar values ('two', 2, 20);

set optimization level 513;
select /*+ RECOMPILE ordered USE_MERGE */
f.*, b.*
from foo f join bar b on f.i=b.i and f.j=b.i
and f.k < b.k;

select /*+ RECOMPILE ordered USE_NL */
f.*, b.*
from foo f join bar b on f.i=b.i and f.j=b.i
and f.k < b.k;

drop foo,bar;

create table foo (i int, j int, k int);
insert into foo values (1, 1, 1);
insert into foo values (1, 1, 2);
insert into foo values (2, 1, 1);

create table bar (v varchar(10), i int, k int);
insert into bar values ('one', 1, 2);
insert into bar values ('two', 2, 1);

set optimization level 257;

select /*+ RECOMPILE ORDERED USE_MERGE */
b.v, f.*, b.*
from foo f join bar b on f.i=b.i and f.j=b.i and f.k=b.k;

select /*+ RECOMPILE ORDERED USE_MERGE */
b.v, f.*, b.*
from bar b join foo f on f.i=b.i and f.j=b.i and f.k=b.k;

drop foo,bar;

