--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';

drop table if exists t,s,u;

create table t (a int, b enum('1','2','3','4','5'), c int, d int, e int) ;

insert into t select rownum,1 ,rownum+2,rownum,rownum+2 from db_class a,db_class b ,db_class c limit 50000;

create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);
create index idx_a_b_cd_d on t (a, b, c desc, d);
create index idx_a_c_b_d on t (a, c, b desc, d);
create index idx_a_d_c_b on t (a, d, c desc, b);
create index idx_d_a_c_b on t (d, a, c desc,b);
create index idx_c_a_d_b on t (c, a, d desc,b);
create index idx_c_a_d_b_1 on t (c, a, d ,b);

select /*+ recompile */ count(*) from t
	where a in (1,3) and b = 1
	order by c desc, d for ORDERBY_NUM() BETWEEN 0 AND 1000000000000;


select /*+ recompile */ distinct b from t
	where a in (1,3) and b = 1
	order by b desc for ORDERBY_NUM() BETWEEN 0 AND 2;

select /*+ recompile */ distinct c +d,c  from t
	where a in (1,3) and b = 1
	order by c desc for ORDERBY_NUM() BETWEEN 0 AND 2;

select /*+ recompile */ distinct rownum from t
	where a in (1,3) and b = 1
	order by 1 desc  for ORDERBY_NUM() BETWEEN 0 AND 1;

select /*+ recompile */ distinct * from t
	where a in (1,3) and b = 1
	order by c desc, d limit 5;

drop table if exists t,s,u,b_tbl,a_tbl;

CREATE TABLE a_tbl(

id INT NOT NULL DEFAULT 0 PRIMARY KEY,

phone VARCHAR(10));

CREATE TABLE b_tbl(

ID INT NOT NULL,

name VARCHAR(10) NOT NULL,

CONSTRAINT pk_id PRIMARY KEY(id),

CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES a_tbl(id)

ON DELETE CASCADE ON UPDATE RESTRICT);

INSERT INTO a_tbl VALUES(DEFAULT,'111-1111'), (2,'222-2222'), (3, '333-3333');

INSERT INTO b_tbl VALUES(0,'George'),(2,'Laura'),(3,'Max');

SELECT a.id, b.id, a.phone, b.name FROM a_tbl a, b_tbl b WHERE a.id=b.id;

SELECT a.id, b.id, a.phone, b.name FROM a_tbl a, b_tbl b WHERE a.id=b.id order by a.id desc for ORDERBY_NUM() BETWEEN 0 AND 3;

SELECT a.id, b.id, a.phone, b.name FROM a_tbl a, b_tbl b WHERE a.id=b.id and a.phone like '111%' order by a.id desc for ORDERBY_NUM() BETWEEN 0 AND 3;

SELECT min(a.id) FROM a_tbl a, b_tbl b WHERE a.id=b.id and a.phone like '111%' order by a.id desc for ORDERBY_NUM() >1000 and  ORDERBY_NUM() < 10;

select * from a_tbl order by id for ORDERBY_NUM() >1000 and  ORDERBY_NUM() < 10;

--select min(a.id) from a_tbl a order by id for ORDERBY_NUM() >1000 and  ORDERBY_NUM() < 10;

drop b_tbl,a_tbl;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

