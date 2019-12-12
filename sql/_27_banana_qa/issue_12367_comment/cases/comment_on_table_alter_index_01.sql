drop table if exists index_comment;

create table index_comment(id int primary key, name char(10));
create index i_t_comment_s on index_comment(id desc);

select index_name, class_name, comment from db_index where class_name='index_comment' order by 1,2,3;
alter index i_t_comment_s on index_comment(id, name) where id>10 comment'change index from pk desc to multiple column index' rebuild;
select index_name, class_name, comment from db_index where class_name='index_comment' order by 1,2,3;

show index from index_comment;
insert into index_comment values(1,'aa'),(2,'aca'),(3,'11aa'),(4,'cccaa');
select * from index_comment order by id;

alter table index_comment add index i_index_comment_name(name) comment'add new index on column';
select index_name, class_name, comment from db_index where class_name='index_comment' order by 1,2,3;
select attr_name, class_name, comment from db_attribute where class_name='index_comment' order by 1,2,3;


set names utf8;
drop table if exists index_comment;  

create table index_comment(id int primary key, name char(10));
create index i_t_comment_s on index_comment(id desc);

select index_name, class_name, comment from db_index where class_name='index_comment' order by 1,2,3;
alter index i_t_comment_s on index_comment(id, name) where id>10 comment'change index from pk desc to multiple column index' rebuild;
select index_name, class_name, comment from db_index where class_name='index_comment' order by 1,2,3;


show index from index_comment;
insert into index_comment values(1,'aa'),(2,'aca'),(3,'11aa'),(4,'cccaa');
select * from index_comment order by id;

alter table index_comment add index i_index_comment_name(name) comment'add new index on column';
select index_name, class_name, comment from db_index where class_name='index_comment' order by 1,2,3;
select attr_name, class_name, comment from db_attribute where class_name='index_comment' order by 1,2,3;

set names iso88591;

drop table if exists index_comment;
