drop table if exists t;

create table t (i numeric(10,1), j double,k date,l varchar(200),m char(200),n bigint);

create index idx_t_i on t (i);

create index idx_t_j on t (j);

insert into t select rownum,rownum, TO_DATE('12/25/2008'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;

insert into t select rownum,rownum, TO_DATE('12/25/2009'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;

select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 0 limit 10;

select /*+ recompile */ i,j from t where i > 5 and i < 200 group by j having i > 0 limit 10,20;

select /*+ recompile */ newt.i,newt.j,newt.k from (select i,j,k from t order by 1,2,3) newt  where newt.k >=  TO_DATE('12/25/2008') group by newt.k having newt.k <=  TO_DATE('12/25/2008') limit 10 ;

select /*+ recompile */ i,j,k,l,m,n,count(l) from t where i > 10 and i < 110 group by l having j > 100 limit 2,10;

select /*+ recompile */ newt.i,newt.j,newt.k,newt.l,newt.m,newt.n from (select i,j,k,l,m,n from t order by 1 ,2,3,4,5,6) newt where newt.m > 10 and newt.m < 110 group by newt.m having newt.m > 100 limit 2,10;

select /*+ recompile */ newt.i,newt.j,newt.k,newt.l,newt.m,newt.n,avg(newt.n) from (select i,j,k,l,m,n from t order by 1,2,3,4,5,6 ) newt where newt.n > 10 and newt.n < 110 group by newt.n having newt.n > 100 limit 2,10;

drop table t;

drop table if exists list_tbl,list_tbl2;

CREATE TABLE list_tbl ( col_1 list(CHAR(1)));

INSERT INTO list_tbl VALUES ({'c','c','c','b','b', 'a'});
INSERT INTO list_tbl VALUES ({'c','c','c','b','b', 'a'});
INSERT INTO list_tbl VALUES ({'c','c','c','b','b', 'a'});
INSERT INTO list_tbl VALUES ({'c','c','c','b','b', 'a'});

INSERT INTO list_tbl VALUES ({'c','c','c','b','b', 'b'});
INSERT INTO list_tbl VALUES ({'c','c','c','b','b', 'B'});

CREATE TABLE list_tbl2  like list_tbl;

insert into list_tbl2 select * from list_tbl limit 4 order by 1;

SELECT *,count(*) as b FROM list_tbl where 2 > 1  group by col_1 order by b ;

SELECT col_1 as b ,count(col_1), col_1 as col_b FROM list_tbl where 2 > 1  group by col_1 order by col_1 desc;

SELECT *,count(*) as b FROM list_tbl a ,list_tbl2 b where 2 > 1 and a.col_1=b.col_1 group by a.col_1 order by b ;

SELECT *,count(*) as b FROM list_tbl a ,list_tbl2 b where 2 > 1 and a.col_1=b.col_1  group by a.col_1 order by b ;

drop table if exists list_tbl,list_tbl2;

drop table if exists t1,t2;

CREATE TABLE t1( a int);

INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1);

INSERT INTO t1 VALUES (2);
INSERT INTO t1 VALUES (2);

CREATE TABLE t2 (a int);

insert into t2 select * from t1;
SELECT *,count(*) as b FROM t1 group by t1.a order by b ;

SELECT *,count(*) as b FROM t1 group by t1.a+10000-t1.a+t1.a-10000 order by b ;
--error
SELECT *,count(*) as b FROM t1 where 2 > 1  group by t1 order by b ;

SELECT a as b ,count(a), a as t1 FROM t1 where 2 > 1  group by a order by b desc;

SELECT t1.*,count(*) as b FROM t1,t2  where 2 > 1 and t1.a=t2.a group by t1.a order by b ;

drop table if exists t1,t2;

CREATE TABLE t1( a decimal auto_increment);

INSERT INTO t1 VALUES (null);
INSERT INTO t1 VALUES (default);

CREATE TABLE t2( a decimal auto_increment);

INSERT INTO t2 VALUES (null);
INSERT INTO t2 VALUES (default);

SELECT t1.*,count(*) as b FROM t1,t2  where t1.a=t2.a group by t1.a order by b ;
SELECT t1.*,count(*) as b FROM t1,t2  where t1.a=t2.a group by t1.a+t2.a  order by t1.* desc ;

drop table if exists t1,t2;



