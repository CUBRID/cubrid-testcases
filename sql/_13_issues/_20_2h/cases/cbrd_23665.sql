create table tmp_hls(a varchar(10), b varchar(10), c int);
insert into tmp_hls values('cub','cubrid',1),('ora','oracle',2),('post','postgre',3),('my','mysql',4),('ms','mssql',5),('park','parksehun',1);

-- General test case
set trace on;
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.a = a.a and a.c = b.c and b.b = a.b;
show trace;
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.c = a.c; 
show trace;
select /*+ ordered */ a.* from tmp_hls a, (select * from tmp_hls b where b.c >=3) b, (select * from tmp_hls b where b.c >=3) c where a.a = b.a and b.b = a.b and b.a = c.a; 
show trace;

-- with other predicate
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.c = b.c and a.b > b.b;
show trace;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where a.c = b.c and a.c + b.c = 4;
show trace;
select /*+ ordered */ * from tmp_hls a, (select max(a) a,max(b) b, c from tmp_hls b group by c) b where a.c = b.c and a.c + b.c = 2;
show trace;
select /*+ ordered */ * from tmp_hls a, (select max(a) a,max(b) b, c from tmp_hls b group by c) b where a.c = b.c and a.a > 'cub' and b.b > 'cubrid';
show trace;

-- predicate with function
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where substr(a.b,1,3) = b.a;
show trace;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where substr(a.b,1,3) = decode(b.a,'post','pos',b.a);
show trace;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.a || 'rid' = decode(a.a,'cub','cubrid','post','postgre',a.a);
show trace;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=1) b where b.b = decode(a.a,'cub','cubrid','post','bad',a.b);
show trace;

-- outer join
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=3) b where a.b = b.b(+);
show trace;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=3) b, (select * from tmp_hls b where b.c >=5) c where a.a = b.a(+) and b.b(+) = a.b and a.a = c.a(+); 
show trace;
select /*+ ordered */ * from tmp_hls a, (select * from tmp_hls b where b.c >=3) b, (select * from tmp_hls b where b.c >=5) c where a.a = b.a(+) and b.b(+) = a.b and b.a = c.a(+); 
show trace;

set trace off;

create table tmp_hls_type(col1 varchar(10), col2 int, col3 char(5));
insert into tmp_hls_type values('1',1,'1'),('2',2,'2'),('3',3,'3'),('4',4,'4'),('5',5,'5'),('1',2,'3');

-- different type
set trace on;
select /*+ ordered */ * from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col2 and a.col2 = b.col1 and a.col3 = b.col3;
show trace;
select /*+ ordered */ * from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col3 and a.col3 = b.col1 and a.col2 = b.col2;
show trace;

insert into tmp_hls_type values('park',1,'park');
select /*+ ordered */ * from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col2 and a.col2 = b.col1 and a.col3 = b.col3;
show trace;
select /*+ ordered */ * from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col3 and a.col3 = b.col1 and a.col2 = b.col2;
show trace;

set trace off;
drop table if exists tmp_hls_type;
create table tmp_hls_type(col1 numeric(20,10), col2 int, col3 double, col4 float);
insert into tmp_hls_type values(1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(1,2,3,4);

set trace on;
select /*+ ordered */ a.* from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col2 and a.col2 = b.col3 and a.col3 = b.col4;
show trace;
select /*+ ordered */ a.* from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col2 = b.col1 and a.col3 = b.col2 and a.col4 = b.col3;
show trace;

set trace off;
insert into tmp_hls_type values(1.1,1,1.1,1.1);

set trace on;
select /*+ ordered */ a.* from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col3 and a.col3 = b.col1;
show trace;
select /*+ ordered */ a.* from tmp_hls_type a, (select * from tmp_hls_type where col2 >= 1) b where a.col1 = b.col4 and a.col4 = b.col1;
show trace;

-- in operation
select /*+ ordered */ aa.* from (select * from tmp_hls b where b.c >=1) aa where (aa.a,aa.b,aa.c) in (select a,b,c from tmp_hls);
show trace;
select /*+ ordered */ aa.* from (select * from tmp_hls b where b.c >=1) aa where (aa.a,aa.b) in (select a,b from tmp_hls) and aa.c in (select c from tmp_hls);
show trace;

-- correlated subquery
select /*+ ordered */ aa.* from tmp_hls aa, (select * from tmp_hls b where b.c > aa.c or b.c = 1) b where aa.a = b.a and aa.b = b.b and aa.c = b.c;
show trace;

set trace off;
create table t1 (a int, b int, c int);
insert into t1 select rownum,rownum,rownum from db_class a, db_class b, db_class c, db_class d limit 100000;

-- memory limit, sql hint, trace info
set trace on;
select /*+ ordered */ count(*) from (select * from t1 limit 1) a, (select * from t1 limit 50000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
select /*+ ordered */ count(*) from (select * from t1 limit 1) a, (select * from t1 limit 100000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
-- change max_hash_list_scan_size
set system parameters 'max_hash_list_scan_size=10M';
select /*+ ordered */ count(*) from (select * from t1 limit 1) a, (select * from t1 limit 100000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
set system parameters 'max_hash_list_scan_size=4M';
select /*+ ordered */ count(*) from (select * from t1 limit 1) a, (select * from t1 limit 100000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
select /*+ ordered no_hash_list_scan */ count(*) from (select * from t1 limit 1) a, (select * from t1 limit 50000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;

drop table if exists tmp_hls;
drop table if exists tmp_hls_type;
drop table if exists t1;

set system parameters 'max_hash_list_scan_size=129M';
set system parameters 'max_hash_list_scan_size=0';
set system parameters 'max_hash_list_scan_size=-4M';
set system parameters 'max_hash_list_scan_size=default';
