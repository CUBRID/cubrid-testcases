
--+ holdcas on;

drop table if exists tt,t;
create table t(i bigint primary key, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(200) ) partition by hash(i) partitions 5 ;

insert into t select rownum, rownum, rownum,rownum,STR_TO_DATE('01,5,2013','%d,%m,%Y'),rownum || '' from _db_class limit 5;
create table tt(i int , j int, k int,l int,m date,n char(250),primary key(i,j)) partition by hash(j) partitions 5 ;
insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = i-1, k = k+1;
insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = t.i, k = k+1;

select count(*) from tt;

drop table if exists tt,t;

--+ holdcas off;
commit;
