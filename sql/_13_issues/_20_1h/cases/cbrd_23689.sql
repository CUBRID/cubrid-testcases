set system parameters 'dont_reuse_heap_file=yes';
drop table if exists tmp1;
drop table if exists tmp2;

CREATE TABLE tmp1 (col1 VARCHAR(10), col2 VARCHAR(10));
CREATE TABLE tmp2 (col1 VARCHAR(10), col2 VARCHAR(10));
INSERT INTO tmp1 SELECT ROWNUM, (ROWNUM +1)/10000 FROM db_class a, db_class b, db_class c LIMIT 10000;
INSERT INTO tmp2 SELECT ROWNUM, ROWNUM FROM db_class a, db_class b, db_class c LIMIT 10000;
CREATE INDEX cub11 ON tmp1(col1);
CREATE INDEX cub22 ON tmp1(col1,col2);
CREATE INDEX cub11 ON tmp2(col1);
CREATE INDEX cub22 ON tmp2(col1,col2);
CREATE INDEX cub33 ON tmp2(col2,col1);
UPDATE STATISTICS ON all classes with fullscan;
set optimization level 513;

select /*+ recompile */ count(1)
from tmp1 a, tmp1 b, tmp2 c
where a.col1 = b.col1(+)
and a.col1 = c.col1
and c.col2 = 2;

drop table if exists tmp1;
drop table if exists tmp2;
set system parameters 'dont_reuse_heap_file=no';
