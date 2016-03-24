create table t1 (id int primary key, a int, b int, c int);
create index i_ac on t1(a,c);
insert into t1 select rownum, rownum%5, rownum, rownum from db_class x1, db_class x2, db_class limit 10000;

create table t2 (id int primary key, a int, b int, c int);
create index i_ac on t2(a,c);
insert into t2 select * from t1;

--@queryplan
select /*+ recompile index_ss(t1) ordered */ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t2) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t1,t2) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t2,t1) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(*) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss() ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t1) no_index_ss ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t2) no_index_ss ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t1,t2) no_index_ss ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss() no_index_ss ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t2) no_index_ss(t1) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t1) no_index_ss(t1) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss index_ss(t1) ordered*/ * from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t1) index_ss(t2) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(t2) index_ss(t1) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1;
--@queryplan
update /*+ recompile index_ss(t2) index_ss(t1) ordered*/ t1 set c=c where t1.b<5 and t1.c<5 limit 1;

--@queryplan
select /*+ recompile index_ss */ * from 
((select /*+ recompile index_ss(t1) ordered*/ t1.* from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 order by 1 limit 1)
union
(select /*+ recompile index_ss(t2) ordered*/ t1.* from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 order by 1 desc limit 1));

--@queryplan
prepare stmt from 'select /*+ recompile index_ss(?) ordered*/ 1 from t1, t2 where t1.b<5 and t1.c<5 and t2.c<5 limit 1';
--@queryplan
execute stmt using 't1';
deallocate prepare stmt;

--@queryplan
select /*+ recompile index_ss(s1) ordered */ 1 from t1 as s1, t2 as s2 where s1.b<5 and s1.c<5 and s2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(s2) ordered */ 1 from t1 as s1, t2 as s2 where s1.b<5 and s1.c<5 and s2.c<5 limit 1;
--@queryplan
select /*+ recompile index_ss(s1,s2) ordered */ 1 from t1 as s1, t2 as s2 where s1.b<5 and s1.c<5 and s2.c<5 limit 1;

create view v1 as select /*+ recompile index_ss(s1) ordered */ 1 col from t1 as s1, t2 as s2 where s1.b<5 and s1.c<5 and s2.c<5 limit 1;
--@queryplan
select /*+ recompile */ * from v1;
--@queryplan
select /*+ recompile index_ss */ * from v1;
drop view v1;

drop table t1;
drop table t2;


