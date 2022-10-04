drop table if exists tbl;
create table tbl (cola int, colb int);
insert into tbl select rownum, rownum from db_class a, db_class b, db_class c, db_class d limit 100000;
create index idx on tbl(cola);
set trace on;

prepare stmt from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?,?';

execute stmt using 100,10;
show trace;
set trace off;

deallocate prepare stmt;
drop table if exists tbl;

