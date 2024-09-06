-- refer to sql/_13_issues/_20_2h/cases/cbrd_23665.sql

create table tmp_hls(a varchar(10), b varchar(10), c int);
insert into tmp_hls values('cub','cubrid',1),('ora','oracle',2),('post','postgre',3),('my','mysql',4),('ms','mssql',5),('park','parksehun',1);

-- with other predicate
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.c = b.c and a.b > b.b;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.c = b.c and a.c + b.c = 4;

-- predicate with function
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where substr(a.b,1,3) = b.a;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where substr(a.b,1,3) = decode(b.a,'post','pos',b.a);
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.a || 'rid' = decode(a.a,'cub','cubrid','post','postgre',a.a);
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.b = decode(a.a,'cub','cubrid','post','bad',a.b);

drop table if exists tmp_hls;
drop table if exists tmp_hls_type;
