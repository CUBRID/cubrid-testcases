--+ holdcas on;
drop table if exists t1,t2;
CREATE TABLE t1 (a INT, b CHAR(3), c INT);
CREATE TABLE t2 (a INT, b CHAR(3), c INT);

create index  i_t1_a_c on   t1 (a, c);
create index   i_t2_a_c on  t2 (a, c);

insert into t1 values(1,1,1);
insert into t2 values(1,1,1);
update statistics on all classes;
select * from (t1,t2) s order by 1;

select  /*+ recompile */ *  from (t1,t2) s order by 1 ;

select * from (t1,t2) s where c=1 using index none order by 1;

select  /*+ recompile */ *  from (t1,t2) s where s.c=1 using index none order by 1;

select  /*+ recompile */ *  from (t1,t2) s order by 1;

--below statement will throw a core file.
select /*+ recompile */ * from (t1,t2) s where c=9 using index i_t1_a_c order by 1;

drop table if exists t1,t2,t3,t4;

CREATE TABLE t1 (a INT, b CHAR(3), c INT);
CREATE TABLE t2 (a INT, b CHAR(3), c INT);
CREATE TABLE t3 (a INT, b CHAR(3), c INT);
CREATE TABLE t4 (a INT, b CHAR(3), c INT);
create index  i_t1_a_c on   t1 (a, c);
create index   i_t2_a_c on  t2 (c);
create index  i_t1_a_c on   t3 (a, c);
create index   i_t2_a_c on  t4 (a, c);

insert into t1 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
insert into t2 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
insert into t3 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
insert into t4 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
update statistics on all classes;
set optimization level 513;
select * from (t1,t2,t3,t4) s order by 1;
select /*+ recompile */ a,c  from (t1) where c=1 using index i_t1_a_c order by 1;

select /*+ recompile */ *  from (t1) s where c=1 using index i_t1_a_c order by 1;

select /*+ recompile */ a,c  from (t1) where a=1 using index i_t1_a_c order by 1;

select /*+ recompile */ *  from (t1) where a=1 using index i_t1_a_c order by 1;

select /*+ recompile */ c  from t2 where a=1 using index i_t2_a_c order by 1;

select /*+ recompile */ c  from t2 where c=1 using index i_t2_a_c order by 1;

select /*+ recompile */ * from (t1,t2,t3,t4) s where c=1 using index i_t1_a_c;

select /*+ recompile */ * from (t1,t2,t3,t4,t1,t2,t3,t4) s where c=1 using index i_t1_a_c,i_t2_a_c;

select /*+ recompile */ * from (t1,t2,t3,t4,t1,t2,t3,t4) s using index i_t1_a_c,i_t2_a_c;

drop table if exists t1,t2,t3,t4;

CREATE TABLE t1 (a INT, b CHAR(3), c INT) partition by hash(a) partitions 3;;
CREATE TABLE t2 (a INT, b CHAR(3), c INT) partition by hash(b) partitions 3;;
CREATE TABLE t3 (a INT, b CHAR(3), c INT) partition by hash(c) partitions 3;;
CREATE TABLE t4 (a INT, b CHAR(3), c INT) partition by hash(a) partitions 3;;
create index  i_t1_a_c on   t1 (a, c);
create index   i_t2_a_c on  t2 (c);
create index  i_t1_a_c on   t3 (a, c);
create index   i_t2_a_c on  t4 (a, c);

insert into t1 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
insert into t2 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
insert into t3 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
insert into t4 select rownum,rownum ,rownum from db_class a,db_class b limit 500;
update statistics on all classes;
set optimization level 513;
select * from (t1,t2,t3,t4) s order by 1;
select /*+ recompile */ a,c  from (t1) where c=1 using index i_t1_a_c order by 1;

select /*+ recompile */ *  from (t1) s where c=1 using index i_t1_a_c order by 1;

select /*+ recompile */ a,c  from (t1) where a=1 using index i_t1_a_c order by 1;

select /*+ recompile */ *  from (t1) where a=1 using index i_t1_a_c order by 1; 

select /*+ recompile */ c  from t2 where a=1 using index i_t2_a_c order by 1; 

select /*+ recompile */ c  from t2 where c=1 using index i_t2_a_c order by 1;

select /*+ recompile */ * from (t1,t2,t3,t4) s where c=1 using index i_t1_a_c;

select /*+ recompile */ * from (t1,t2,t3,t4,t1,t2,t3,t4) s where c=1 using index i_t1_a_c,i_t2_a_c;

select /*+ recompile */ * from (t1,t2,t3,t4,t1,t2,t3,t4) s using index i_t1_a_c,i_t2_a_c;

drop table  t1,t2,t3,t4;
commit;
--+ holdcas off;
