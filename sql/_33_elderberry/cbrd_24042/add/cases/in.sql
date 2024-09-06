-- refer to sql/_13_issues/_20_2h/cases/cbrd_23665.sql

create table tmp_hls(a varchar(10), b varchar(10), c int);
insert into tmp_hls values('cub','cubrid',1),('ora','oracle',2),('post','postgre',3),('my','mysql',4),('ms','mssql',5),('park','parksehun',1);
create table tmp_hls_type(col1 numeric(20,10), col2 int, col3 double, col4 float);
insert into tmp_hls_type values(1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(1,2,3,4);

-- in operation
select /*+ ordered */ aa.* from (select * from tmp_hls b where b.c >=1) aa where (aa.a,aa.b,aa.c) in (select a,b,c from tmp_hls);
select /*+ ordered */ aa.* from (select * from tmp_hls b where b.c >=1) aa where (aa.a,aa.b) in (select a,b from tmp_hls) and aa.c in (select c from tmp_hls);

drop table if exists tmp_hls;
drop table if exists tmp_hls_type;
