create table a(id int,col char(2) unique);
create index id on a(id);
select /*+ recompile */ id,col from a where id=5 and col='a';
drop table a;

