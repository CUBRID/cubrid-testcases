create table t( a varchar(10));
insert into  t value('SQL');
create index idx on t(a) where LOWER(a) ='sql';
select /*+ RECOMPILE */* from t where LOWER(a) = 'sql' using index idx(+);
drop table t;

