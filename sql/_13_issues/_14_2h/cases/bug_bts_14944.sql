-- This issue also verifies CBRD-24638.
-- Column default value problem when altering column type.
-- Altering default value column is allowed.

drop table if exists stu;
create table stu(id int,addr varchar(200)) comment 'this table store the student information';
show full columns from stu;
show create table stu;
alter table stu add column phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
show create table stu;
alter table stu modify phone varchar(2000) comment 'ggggggggggggg';
show full columns from stu;
alter table stu modify id int comment 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
show full columns from stu;
show create table stu;
select * from db_attribute where class_name='stu' order by 1;
drop  stu;


drop table if exists g;
create table g(i enum('red','blue') comment 'asdddf');
show full columns from g;
alter table g modify i int comment 'my idol is Steve Jobs';
select * from db_attribute where class_name='g' order by 1;
show create table g;
select * from db_attribute where class_name='g' order by 1;
show create table g;
show full columns from g;

drop table if exists g;
create table g(i int auto_increment comment 'sky') comment 'gary';
show create table g;
show full columns from g;
alter table g modify i int primary key comment 'sea';
show create table g;
show full columns from g;
alter table g modify i char(5000) comment 'go with the wind';
show full columns from g;
alter table g add col_short short comment ' 你好，china';
alter table g add col_smallint short comment ' 陶渊明';
alter table g add col_bigint bigint comment 'BAT';
alter table g add col  decimal(8,2) comment 'the meaning of life';
show full columns from g;
alter table g drop column col;
alter table g drop col_bigint;
alter table g drop col_smallint;
show full columns from g;
alter table g modify col_bigint bigint comment '大学之道在明明德';
show full columns from g;
alter table g modify col_short bigint comment '大学之道在明明德';
show full columns from g;
drop g;



drop table if exists `hg_pay_exchange`;
CREATE TABLE `hg_pay_exchange` (
  `id` int  NOT NULL AUTO_INCREMENT COMMENT 'id',
  `module` varchar(15) NOT NULL,
  `type` enum('amount','point') NOT NULL,
  `number` decimal(8,2) NOT NULL,primary key(`id`));
  show full columns from `hg_pay_exchange`;

alter table `hg_pay_exchange` modify `type`  char(500) comment '`go with the wind`';
show full columns from `hg_pay_exchange`;
select * from db_attribute where class_name='hg_pay_exchange' order by 1;
show create table `hg_pay_exchange`;
drop table `hg_pay_exchange`;

drop table if exists t;
create table t(i double primary key comment 'abcdef' );
insert into t select rownum from db_root connect by level<100;
show  full columns from t;
alter table t comment 'abcdefghijk';
alter table t change  i id int auto_increment comment 'qazwsx';
show full columns from t;

drop table if exists t;
create table t(i int comment 'id' ,name varchar(50) comment 'name' )  comment 'table has range partitions' partition by range(i)
(partition p0 values less than (10),
partition p1 values less than (100),
partition p2 values less than maxvalue) ;
show create table t;
 select * from db_attribute where class_name='t' order by 1;
show full columns from t;

drop table if exists t;
create table t(i int) comment 'table t';
create index idx on t(i) comment 'index';
 show indexes from t;
 show create table t;

drop view if exists view1;
insert into t select rownum from db_root connect by level<=200;
create view view1 as select i from t where i<=100;
alter view view1 comment 'view for table t';
show create view view1;
alter table t  comment 'table comparision';
show create table t;

drop table if exists t;
create table t(i int);
create index idx on t(i) comment 'index';
 show indexes from t;
 show create table t;

drop view if exists view1;
insert into t select rownum from db_root connect by level<=200;
create view view1 as select i from t where i<=100;
alter view view1 comment 'view for table t';
show create view view1;
alter table t  comment 'table comparision';
show create table t;
select * from db_attribute where class_name='view1' order by 1;
select * from db_attribute where class_name='t' order by 1;
drop t;
drop view1;


dro p table if exists tt;
-- create table with attribute comment
create table tt (a int comment 'col a comment');

show create table tt;
select attr_name, class_name, comment from db_attribute where class_name = 'tt' order by 1;
show full columns from tt;

-- alter table add column with comment
alter table tt add column b int comment 'comment for col b';

show create table tt;
select attr_name, class_name, comment from db_attribute where class_name = 'tt' order by 1;
show full columns from tt;

-- alter table modify column comment
alter table tt modify a int comment 'new comment for col a';

show create table tt;
select attr_name, class_name, comment from db_attribute where class_name = 'tt' order by 1;
show full columns from tt;

-- alter table change column with comment
alter table tt change b x double comment 'newest x';

show create table tt;
select attr_name, class_name, comment from db_attribute where class_name = 'tt' order by 1;
show full columns from tt;

-- alter attribute comment with 1024 length
alter table tt modify a int comment '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';

show create table tt;
select attr_name, class_name, comment from db_attribute where class_name = 'tt' order by 1;
show full columns from tt;

-- error case with alter attribute comment with 1025 length
alter table tt modify a int comment '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0';

show create table tt;
select attr_name, class_name, comment from db_attribute where class_name = 'tt' order by 1;
show full columns from tt;

drop table tt;


