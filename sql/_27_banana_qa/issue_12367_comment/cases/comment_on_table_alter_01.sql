drop table if exists alt_comment_tbl;


create table alt_comment_tbl(id int, b char(11)) comment='alter table comment testing';
insert into alt_comment_tbl values(1,'22'),(2,'2a2'),(3,'2b2'),(3,'2c2'),(4,'2d2'),(5,'2e2'),(6,'2f2');
select * from alt_comment_tbl order by id, b;
select class_name, comment from db_class where class_name='alt_comment_tbl';
select class_name, comment from _db_class where class_name='alt_comment_tbl';

alter table alt_comment_tbl comment='table''s comment has been modify!';
select class_name, comment from db_class where class_name='alt_comment_tbl';
select class_name, comment from _db_class where class_name='alt_comment_tbl';

alter table alt_comment_tbl comment'table''s comment has been modify for the second time!';
select class_name, comment from db_class where class_name='alt_comment_tbl';
select class_name, comment from _db_class where class_name='alt_comment_tbl';


drop table if exists alter_column_comment;
create table alter_column_comment(id int primary key, name char(6));
insert into alter_column_comment values(1,'commen'),(2,'table'),(3,'column'),(4,'functi');
alter table alter_column_comment modify column id int comment'new comments for column id';
alter table alter_column_comment modify column name char(7) comment'add new comment for column name';
alter table alter_column_comment add column c date comment'current date print';
alter table alter_column_comment change c x double comment'double x comment';
show create table alter_column_comment;
select attr_name, class_name, comment from db_attribute where class_name='alter_column_comment' order by 1,2,3;

drop table if exists alter_idx_comment;
create table alter_idx_comment(id int, b int, c char(10));
create index i_t_alter_idx_com on alter_idx_comment(id) comment'add comment for index';
create index i_t_alter_idx_com_b on alter_idx_comment(id, b) comment'add comment for combine index';

--the below two SQLs is by design behavior according to CUBRIDSUS-16306
create unique index i_t_alt_idx_c  on alter_idx_comment(b) desc comment'create desc unique index';
create unique index i_t_alt_idx_c_2  on alter_idx_comment(b) asc comment'create desc unique index';

create unique index i_t_alt_idx_c_f1  on alter_idx_comment(b desc) comment'create desc unique index';
create unique index i_t_alt_idx_c_2_f2  on alter_idx_comment(b asc) comment'create desc unique index';

insert into alter_idx_comment values(1,2,'cc'),(2,3,'ccaa');
select * from alter_idx_comment order by id;

drop table if exists alter_idx_comment;
drop table if exists alter_column_comment;
drop table if exists alt_comment_tbl;

