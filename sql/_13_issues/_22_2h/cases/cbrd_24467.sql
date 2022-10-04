drop table if exists tbl1;
create table tbl1 (col1 int, col2 int);
insert into tbl1 select rownum, rownum from db_class a, db_class b, db_class c, db_class d limit 100000;
create index idx on tbl1(col1);
set trace on;

prepare stmt from
'SELECT a.col1, a.col2
FROM tbl1 a
         LEFT JOIN tbl1 b ON a.col1 = b.col1
         LEFT JOIN tbl1 c ON a.col1 = c.col1
ORDER BY a.col2,a.col1
LIMIT ?,?';

execute stmt using 100,10;
show trace;
set trace off;

deallocate prepare stmt;
drop table if exists tbl1;

