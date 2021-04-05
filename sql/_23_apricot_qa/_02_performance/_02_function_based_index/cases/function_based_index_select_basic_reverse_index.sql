--+ holdcas on;
create table t (id int primary key, a varchar(10), b varchar(10), c datetime);

create reverse index idx on t(lower(a));

insert into t values (1, '1', '1', DATETIME'03/18/2011');
insert into t values (2, '2', '2', DATETIME'03/18/2011');
insert into t values (0, '0', '0', DATETIME'03/17/2011');
insert into t values (3, '1', '1', DATETIME'03/19/2011');
insert into t values (4, '2', '2', DATETIME'03/19/2011');
--Test
select /*+ recompile */ a,b,c from t where lower(a) > '0' ;
--Test
select /*+ recompile */ b,c from t where lower(a)>'0' ;
--Test
select /*+ recompile */ c, count(*) from t where lower(a)>'0' group by c having count(*)>1 ;
--Test
select /*+ recompile */ c, count(*) from t where lower(a)>'0' group by c desc having count(*)>1 ;

drop table t;


commit;
--+ holdcas off;
