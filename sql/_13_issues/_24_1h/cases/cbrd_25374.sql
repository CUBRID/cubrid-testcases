-- sort-limit-optimization does not work when there is an expression containing a bind variable in the limit clause.

-- Check SORT (limit) in plan section and SUBQUERY (uncorrelated) in statistics section. 

-- left join
drop table if exists tbl;
create table tbl (cola int, colb int);
insert into tbl select rownum, rownum  from db_class a, db_class b, db_class c, db_class d limit 100000;
create index idx on tbl(cola);
set trace on;

prepare stmta from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?*10,?';
execute stmta using 10,10;
show trace;

prepare stmta from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?*?,?';
execute stmta using 10,10,10;
show trace;

prepare stmta from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?,?';
execute stmta using 100,10;
show trace;

prepare stmta from
'SELECT a.cola, a.colb
FROM tbl a
         LEFT JOIN tbl b ON a.cola = b.cola
         LEFT JOIN tbl c ON a.cola = c.cola
ORDER BY a.colb,a.cola
LIMIT ?,10*?';
execute stmta using 100,1;
show trace;

set trace off;
-- inner join 
drop table if exists u;
drop table if exists t;

create table t(i int primary key, j int, k int);
create table u(i int not null, j int, k int);
alter table u add constraint fk_t_u_i foreign key(i) references t(i);
create index i_u_j on u(j);

insert into t select rownum, rownum, rownum from _db_class a, _db_class b limit 1000;
insert into u select 1+(rownum % 1000), rownum, rownum from _db_class a, _db_class b, _db_class c limit 2000;

set trace on;

prepare stmtb from
'select /*+ recompile */ * 
from u, t where u.i = t.i and u.j > 0 
order by u.j 
limit ?*5,?';
execute stmtb using 2,2;
show trace;

prepare stmtb from
'select /*+ recompile */ * 
from u, t where u.i = t.i and u.j > 0 
order by u.j 
LIMIT ?*?,?';
execute stmtb using 2,5,2;
show trace;

prepare stmtb from
'select /*+ recompile */ * 
from u, t where u.i = t.i and u.j > 0 
order by u.j 
LIMIT ?,?';
execute stmtb using 10,2;
show trace;

prepare stmtb from
'select /*+ recompile */ * 
from u, t where u.i = t.i and u.j > 0 
order by u.j 
LIMIT ?,10*(?/?)';
execute stmtb using 10,1,5;
show trace;


set trace off;

drop prepare stmta;
drop prepare stmtb;
drop table tbl;
drop table u;
drop table t; 
