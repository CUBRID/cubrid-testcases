--+ holdcas on;
drop table if exists t;
create table t (a int, b varchar(128), c float, u_a int, u_b varchar(128), u_c float);
insert into t values (1, 'a', 0.1, NULL, NULL, NULL);
insert into t values (2, 'b', 0.2, NULL, NULL, NULL);
insert into t values (3, 'c', 0.3, NULL, NULL, NULL);
insert into t values (4, 'd', 0.4, NULL, NULL, NULL);
set @a = 0;
--@queryplan
select /*+ recompile */ b, (select @a := @a + a from t union select @a := @a + a from t order by 1 desc limit 1) from t tt;
drop variable @a;
drop table t;

--+ holdcas off;
