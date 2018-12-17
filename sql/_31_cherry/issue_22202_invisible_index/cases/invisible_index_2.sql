drop table if exists test_tb;

create table test_tb (id int auto_increment, a int);

create index i_all on test_tb(id, a) invisible;

insert into test_tb values (null, 1);

select /*+ recompile */ * from test_tb where id=last_insert_id();

select /*+ recompile */ * from test_tb where id=ceil(0.6);

select /*+ recompile */ * from test_tb where id>row_count();

alter index i_all on test_tb visible;

select /*+ recompile */ * from test_tb where id=last_insert_id();

select /*+ recompile */ * from test_tb where id=ceil(0.6);

select /*+ recompile */ * from test_tb where id>row_count();

drop table test_tb;


