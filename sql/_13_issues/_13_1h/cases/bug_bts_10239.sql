
--+ holdcas on;
drop if exists t1,s1k; 

create table s1k (a int Primary key);

insert into s1k select rownum from db_class c1, db_class c2 limit 1000;

drop if exists t1; 

create table  t1(i int unique);

insert into t1 select 500 + rownum from s1k a,s1k b , s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

drop t1; 
commit;

--+ holdcas on;
create table  t1(i int primary key);

insert into t1 select 500 + rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

drop t1; 
commit;

--+ holdcas on;
create table  t1(i int,j int, primary key(j,i));

insert into t1 select 500 + rownum,500-rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum from s1k a, s1k b,s1k c limit 2000;


drop t1; 


--+ holdcas on;
create table  t1(i int,j int);

create unique index i_t1_i_j on t1 (j,i);

insert into t1 select 500 + rownum,500-rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

drop t1; 
commit;

--+ holdcas on;
create table  t1(i bigint,j short);

create unique index i_t1_i_j on t1 (j,i);

insert into t1 select 500 + rownum,500-rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;

insert into t1 select rownum,rownum from s1k a, s1k b,s1k c limit 2000;
drop if exists t1,s1k; 
commit;

--+ holdcas off;