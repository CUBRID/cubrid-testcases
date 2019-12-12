drop table if exists test;
CREATE TABLE test
 (sno       NUMERIC(6),
  last_name VARCHAR(30),
  salary   int)
  PARTITION BY RANGE (ceil(salary))
  (
     PARTITION p1 VALUES LESS THAN (5000)  ,
     PARTITION p2 VALUES LESS THAN (10000) ,
     PARTITION p3 VALUES LESS THAN (15000)  ,
     PARTITION p4 VALUES LESS THAN (20000)
 ) ;
create index idx1 on test(sno);
create index idx2 on test(last_name);
create index idx3 on test(sno,salary);
create unique index idxu1 on test(sno,last_name,salary);
create unique index idxu2 on test (salary);
insert into test(salary) values(12);
insert into test(salary) values(10012);
insert into test(salary) values(15012);
insert into test  values(1,'aaa',20000);
alter table test add partition (partition p5 values less than maxvalue);
insert into test  values(1,'aaa',20000);
select distinct  count( *) from test partition(p1);
select count( *) from test partition(p2);
select count(*) from test partition(p3);
select  distinct  count(*) from test partition(p4);
select distinct  count( *) from test partition(p5);
select  * from test partition(p3) where salary<15000;
select  * from test partition(p2) where salary<15000;
update statistics on all classes with fullscan;
show index from test;
show index from test__p__p1;
show index from test__p__p2;
show index from test__p__p3;
show index from test__p__p4;
show index from test__p__p5;
drop table test;

drop table if exists members;
CREATE TABLE members (
    id INT auto_increment ,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob DATE,
    primary key(id,dob)
)
PARTITION BY RANGE( YEAR(dob) ) (
    PARTITION p0 VALUES LESS THAN (1970),
    PARTITION p1 VALUES LESS THAN (1980),
    PARTITION p2 VALUES LESS THAN (1990)
);
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (2000));
	
insert into members  select rownum,'fgo'||rownum,'lgo'||rownum,'1969-10-1' from db_root connect by level<=5;
insert into members  select rownum,'fgt'||rownum,'lgt'||rownum,'1979-10-1' from db_root connect by level<=5;
insert into members  select rownum,'fgh'||rownum,'lgh'||rownum,'1989-10-1' from db_root connect by level<=5;
insert into members  select rownum,'fgf'||rownum,'lgf'||rownum,'1999-10-1' from db_root connect by level<=5;

select  * from members partition(p2) where year(dob)<2000 order by 1;
select  * from members partition(p2) where id<3 order by 1;


update statistics on all classes with fullscan;
show index from members;
show index from members__p__p0;
show index from members__p__p1;
show index from members__p__p2;
show index from members__p__p3;


select  id,fname,lname,dob from members partition(p0) where id<3 order by id,dob;
insert into members partition(p0) select  id,fname,lname,'1968-10-1' from members partition(p2) where id<3;
select  * from members partition (p1) where id= (select id from members where id<3 and year(dob)<1990 order by id limit 1) and year(dob)<2000 order by 1;
select  * from members partition (p1) where id in (select id from members where id<3 and year(dob)<1990 order by id limit 2) and year(dob)<2000 order by 1;

insert into members partition(p0) select  id+5,fname,lname,dob from members partition(p2) where id<3;
select  id,fname,lname,dob from members partition(p0) where id<3 order by id,dob;
insert into members  select  id+5,fname,lname,dob from members partition(p2) where id<3;
select * from members partition(p2) order by 1,2;
select * from members partition(p0) order by 1,2;
delete from members where id  in (select id from members partition(p2) where id<3);
select * from members partition(p2) order by 1,2;
select * from members partition(p0) order by 1,2;
select * from members partition(p1) order by 1,2;
select * from members partition(p3) order by 1,2;
delete from members partition(p1) where dob in (select dob from members partition(p2) where id<3);
delete from members partition(p1) where dob in (select dob from members partition(p2));
delete from members  where dob in (select dob from members partition(p2));
select * from members partition(p2) order by 1,2;
select * from members partition(p0) order by 1,2;
drop table members;
