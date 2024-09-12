-- refer to sql/_22_news_service_mysql_compatibility/_03_hint_rewriting/cases/_01_qualified_names.sql

create table tj (id int, val string);
create table tk (id int, val string);

create index tj_id on tj(id);
create index tk_id on tk(id);

insert into tj values (1, 'value a1');
insert into tj values (2, 'value a2');
insert into tj values (3, 'value a3');
insert into tk values (1, 'value b1');
insert into tk values (2, 'value b2');
insert into tk values (3, 'value b3');

-- ordered + subquery tests (mergable)
select 'test1';
select /*+ recompile ordered  */ * from (select a.val as av, b.val as bv from tj a use index (tj_id) inner join tj b use index (tj_id) on a.id = b.id) sq order by av, bv;
select 'test2';
select /*+ recompile ordered */ * from (select x.id as id, tk.val as val from tj x use index (tj_id) inner join tk on x.id = tk.id) sq order by sq.id;

-- refer to sql/_13_issues/_20_2h/cases/cbrd_23665.sql
create table tmp_hls(a varchar(10), b varchar(10), c int);
insert into tmp_hls values('cub','cubrid',1),('ora','oracle',2),('post','postgre',3),('my','mysql',4),('ms','mssql',5),('park','parksehun',1);

-- ordered + subquery tests (mergable)
select 'test3';
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.a = b.a and a.b = b.b and a.c = b.c;
select 'test4';
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.a = a.a and a.c = b.c and b.b = a.b;
select 'test5';
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.c = a.c; 
select 'test6';
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=3) b, (select * from tmp_hls b where b.c >=3) c where a.a = b.a and b.b = a.b and b.a = c.a; 

-- ordered + in operation (mergable)
select 'test7';
select /*+ ordered */ aa.* from (select * from tmp_hls b where b.c >=1) aa where (aa.a,aa.b,aa.c) in (select a,b,c from tmp_hls);
select 'test8';
select /*+ ordered */ aa.* from (select * from tmp_hls b where b.c >=1) aa where (aa.a,aa.b) in (select a,b from tmp_hls) and aa.c in (select c from tmp_hls);

-- with other predicate (mergable)
select 'test9';
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.c = b.c and a.b > b.b;
select 'test10';
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.c = b.c and a.c + b.c = 4;

-- predicate with function (mergable)
select 'test11';
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where substr(a.b,1,3) = b.a;
select 'test12';
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where substr(a.b,1,3) = decode(b.a,'post','pos',b.a);
select 'test13';
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.a || 'rid' = decode(a.a,'cub','cubrid','post','postgre',a.a);
select 'test14';
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.b = decode(a.a,'cub','cubrid','post','bad',a.b);

-- drop tables
drop table tj;
drop table tk;
drop table if exists tmp_hls;
drop table if exists tmp_hls_type;
