-- sort-limit-optimization does not work when there is an expression containing a bind variable in the limit clause.

-- Check SORT (limit) in plan section and SUBQUERY (uncorrelated) in statistics section. 

drop table if exists tbl;
create table tbl (cola int, colb int);
insert into tbl select rownum, rownum  from db_class a, db_class b, db_class c, db_class d limit 100000;
create index idx on tbl(cola);
set trace on;

prepare stmt from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?*10,?';
execute stmt using 10,10;
show trace;

prepare stmt from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?*?,?';
execute stmt using 10,10,10;
show trace;

prepare stmt from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?,?';
execute stmt using 100,10;
show trace;

prepare stmt from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?,10*?';
execute stmt using 100,1;
show trace;

set trace off;

drop prepare stmt;
drop table tbl;
