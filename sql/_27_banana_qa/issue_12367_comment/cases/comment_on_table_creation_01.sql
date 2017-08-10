drop table if exists t_comment;

create table t_comment(id int, b int) comment='basic comments testing';
insert into t_comment values(1,2),(2,3),(3,4);
select id, b from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';

drop class if exists t_comment;
create class t_comment(id int, b int) comment='basic comments testing';
insert into t_comment values(1,2),(2,3),(3,4);
select id, b from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';

drop table if exists t_comment;
create table t_comment(id int, b int) comment'basic comments testing without equel';
insert into t_comment values(4,5),(5,6),(6,7);
select id, b from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';

drop table if exists t_comment;
create class t_comment(id int, b int) COMMENT'basic comments testing without equel';
insert into t_comment values(4,5),(5,6),(6,7);
select id, b from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';

drop table if exists t_comment;
create table t_comment(id int, comment varchar(20) default 'COMMENT=aaaa') COMMENT'basic comments testing without equel';

drop table if exists comment, comment_11;
create table comment comment'comment for table without attribute';
create table comment_11 like comment comment'comment for table when create it with like keyword';
insert into t_comment values(4,5),(5,6),(6,7);
select id, comment from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='comment';
select class_name, comment from _db_class where class_name='comment_11';
drop table if exists comment, comment_11, t_comment;

drop table if exists t_comment_1, t_comment_2;
create table t_comment_1(id int primary key auto_increment, name char(10)) comment='complex comments testing';
create table t_comment_2 like t_comment_1 comment='complex comments for table 2';
insert int t_comment_1 values(1,'comment');
insert int t_comment_1(name) values(1,'comment=comment');
insert int t_comment_2 values(1,'comment');
insert int t_comment_2(name) values(1,'comment=comment');
select id, name from t_comment_1 order by id;
show create table t_comment_1;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';
show create table t_comment_2;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';

drop table if exists t_comment_1, t_comment_2;

drop table if exists t_comment;
create table t_comment(id int, comment varchar(20) default 'COMMENT=aaaa') COMMENT'basic comments testing without equel'
partition by range(id)(
partition bef_20 values less than (20),
partition bef_30 values less than (30));
insert into t_comment values(4,5),(21,6);
select id, comment from t_comment order by id;
select * from t_comment order by id;
show create table t_comment;
select class_name, comment from db_class where class_name='t_comment';
select class_name, comment from _db_class where class_name='t_comment';
drop table if exists comment;

drop table t_comment;
