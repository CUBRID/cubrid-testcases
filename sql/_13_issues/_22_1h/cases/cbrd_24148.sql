DROP TABLE IF EXISTS tbl_hls ;
-- column d (joined below so that it is kept in the inline views) widens the tuples so that the sorted
-- inline view spans enough temp pages for a parallel list scan
CREATE TABLE tbl_hls (a INTEGER, b INTEGER, c INTEGER, d VARCHAR(60));
insert into tbl_hls select /*+ NO_PARALLEL_SCAN */ r,r,r,lpad(r,60,'0') from (select rand(1)%5000 as r from db_class a, db_class b, db_class c, db_class d limit 410000);

set trace on;
select /*+ recompile ordered */ count(*) from (select /*+ NO_PARALLEL_SCAN */ * from tbl_hls order by a,b,c limit 0,10000) a, (select /*+ NO_PARALLEL_SCAN */ * from tbl_hls limit 0,410000) b where a.a = b.a and a.b = b.b and a.c = b.c and a.d = b.d;
show trace;
set trace off;

drop table tbl_hls;
