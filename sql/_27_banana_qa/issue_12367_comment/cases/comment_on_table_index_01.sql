drop table if exists index_comment;
create table index_comment(id int primary key, name char(10));

--error will be return as by design in issue CUBRIDSUS-16311
create index i_t_comment_s on index_comment(id) comment='basic index comments with desc';
create index i_t_comment on index_comment(id desc) comment'basic index comments with desc';
create index i_t_comment2 on index_comment(id asc) comment'basic index comments with asc';
create index i_t_id_name on index_comment(id, name) comment'basic mix index comment for table';
create index i_t on index_comment(cast(id as double)) comment'add function index for table';
create index i_t_name on index_comment(trim(name)) comment'add function index for table';
create index i_t_id on index_comment(id) where id>5 comment='this is a filter index comments';

show create table index_comment;
select index_name, class_name, comment from db_index where class_name='index_comment';
show index from index_comment;

drop index i_t_comment on index_comment;
drop index i_t_name on index_comment;
drop index index_comment on index_comment;
drop index i_t_id on index_comment;

create unique index i_t_id on index_comment(id) comment 'this is a comment for unique index';
create reverse index i_r_t_id on index_comment(id) comment 'this is a comment for reverse index';
show create table index_comment;
select index_name, class_name, comment from db_index where class_name='index_comment';
show index from index_comment;


drop table index_comment;
