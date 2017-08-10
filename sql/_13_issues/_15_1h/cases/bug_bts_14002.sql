get optimization level into :c;
drop table if exists sinfo,sscore,scourse;
create table sinfo(id bigint auto_increment,name varchar(20),address varchar(100) , telephone char(11)) auto_increment=07010010 reuse_oid;

insert into sinfo select null,null,null,null from db_root connect by level<=1000;

insert into sinfo values(07010001,'lindaiyu','ancient mansion of jia','10000000002');

insert into sinfo values(07010003,'jiabaoyu','ancient mansion of jia','10000000004');

insert into sinfo values(07010005,'xuebaocai','ancient mansion of jia','10000000006');

insert into sinfo values(07010007,'shixiangyun','ancient mansion of jia','10000000008');

insert into sinfo values(07010009,'wangxifeng','ancient mansion of jia','10000000010');

insert into sinfo select null,null,null,null from db_root connect by level<=1000;

create index x_idx on sinfo(id);

create table sscore(id bigint,course_id int  ,score double ) reuse_oid;

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

create index y_idx on sscore(id,course_id);

create table scourse(course_id int ,course_name varchar(50) default 'language') reuse_oid;

insert into scourse values(1,'math');

insert into scourse values(2,'literature');

insert into scourse values(3,'science');

insert into scourse values(4,'physical');

insert into scourse values(5,'chemistry');

insert into scourse  select null ,null from db_root connect by level<=30;

create index z_idx on scourse(course_id);

update statistics on all classes with fullscan;
set optimization level 514;
select /*+ recompile ordered */ x.*,y.*,z.* from sinfo x,sscore y,scourse z where 1=1 and x.id=y.id and y.course_id=z.course_id;

select /*+ recompile ordered */ x.*,y.*,z.* from sscore y,sinfo x,scourse z where 1=1 and x.id=y.id and y.course_id=z.course_id;
set optimization level :c;
drop table if exists sinfo,sscore,scourse;
create table sinfo(id bigint auto_increment,name varchar(20),address varchar(100) , telephone char(11)) auto_increment=07010010 reuse_oid;

insert into sinfo select null,null,null,null from db_root connect by level<=1000;

insert into sinfo values(07010001,'lindaiyu','ancient mansion of jia','10000000002');

insert into sinfo values(07010003,'jiabaoyu','ancient mansion of jia','10000000004');

insert into sinfo values(07010005,'xuebaocai','ancient mansion of jia','10000000006');

insert into sinfo values(07010007,'shixiangyun','ancient mansion of jia','10000000008');

insert into sinfo values(07010009,'wangxifeng','ancient mansion of jia','10000000010');

insert into sinfo select null,null,null,null from db_root connect by level<=1000;

create index x_idx on sinfo(id);

create table sscore(id bigint,course_id int  ,score double ) reuse_oid;

insert into sscore values(07010001,1,89);

insert into sscore values(07010001,2,95);

insert into sscore values(07010001,3,76);

insert into sscore values(07010001,4,60);
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

insert into sscore  select rownum,null,80 from db_root connect by level<=50 ;

create index y_idx on sscore(id,course_id);

create table scourse(course_id int ,course_name varchar(50) default 'language') reuse_oid;

insert into scourse values(1,'math');

insert into scourse values(2,'literature');

insert into scourse values(3,'science');

insert into scourse values(4,'physical');

insert into scourse values(5,'chemistry');

insert into scourse  select null ,null from db_root connect by level<=30;

create index z_idx on scourse(course_id);

update statistics on all classes with fullscan;
set optimization level 514;
select /*+ recompile  */ x.*,y.*,z.* from sinfo x,sscore y,scourse z where 1=1 and x.id=y.id and y.course_id=z.course_id;

select /*+ recompile ordered */ x.*,y.*,z.* from sscore y,sinfo x,scourse z where 1=1 and x.id=y.id and y.course_id=z.course_id;
set optimization level :c;
drop table if exists sinfo,sscore,scourse;
