DROP TABLE IF EXISTS tbl_hls ;
CREATE TABLE tbl_hls (a INTEGER, b INTEGER, c INTEGER);
insert into tbl_hls select r,r,r from (select rand(1)%5000 as r from db_class a, db_class b, db_class c, db_class d limit 1000000);

select /*+ recompile ordered */ count(*) from (select * from tbl_hls limit 0,100000) a, (select * from tbl_hls limit 0,1000000) b where a.a = b.a and a.b = b.b and a.c = b.c;

drop table tbl_hls;
