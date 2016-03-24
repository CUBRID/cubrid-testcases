drop table if exists t_comment;

create table t_comment(id int primary key auto_increment comment'this is primary key column', name char(8) comment'this is common column');
insert into t_comment values(1,'Hello');
insert into t_comment values(2,'comment');
select attr_name,class_name,comment from db_attribute where class_name='t_comment' order by 1,2,3;
select * from t_comment order by id;


drop table if exists t_comment;
set names euckr;
create table t_comment(id int primary key auto_increment  comment'this is primary key column', comment char(8) collate euckr_bin comment'this is common column');
insert into t_comment values(1,'Hello');
insert into t_comment values(2,'comment');
select attr_name,class_name,comment from db_attribute where class_name='t_comment' order by 1,2,3;
select * from t_comment order by id;
set names iso88591;

drop table if exists t_comment;

create table t_comment(id int primary key auto_increment comment'this is primary key column', comment char(8) default'xxff' collate utf8_de_exp comment'this is common columnaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
insert into t_comment values(1,'Hello');
insert into t_comment values(2,'comment');
insert into t_comment(id) values(3);
select attr_name,class_name,comment from db_attribute where class_name='t_comment' order by 1,2,3;
select * from t_comment order by id;

drop table if exists t_comment;
-- should be error, '=' only support table and view
create table t_comment(id int primary key auto_increment comment='this is primary key column', comment char(8) default'xyz' utf8_bin comment';create table tbl(a int);');
insert into t_comment values(1,'Hello');
insert into t_comment values(2,'comment');
insert into t_comment(id) values(3);
select * from t_comment order by id;
select attr_name,class_name,comment from db_attribute where class_name='t_comment' order by 1,2,3;

drop table if exists t_comment;
create table t_comment(id int, comment varchar(20) default 'COMMENT=aaaa' COMMENT 'select _utf8''basic comments for column in partition table') comment'partition table comments' partition by range(id)(partition bef_20 values less than (20) comment 'comment on parition column',
partition bef_30 values less than (30));
insert into t_comment values(4,5),(21,6),(28,7);
select id, comment from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment' order by 1,2;
select class_name, comment from _db_class where class_name='t_comment' order by 1,2;

select attr_name, class_name, comment from db_attribute where class_name='t_comment' order by 1,2,3;
select class_name,comment from db_partition order by 1,2; 


drop table if exists comment;

drop table t_comment;
