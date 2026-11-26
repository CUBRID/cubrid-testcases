/*
 * CBRD-28032: a batched nested loop join holds outer rows and reads the inner index for them ahead,
 * and a step holds rows for its correlated subquery in the same way. A row held ahead must change
 * neither the rows of the statement nor its errors.
 *
 *    Case 1: a join step that remembers its keys holds rows for a subquery: no row is returned twice
 *    Case 2: a statement that stops early does not report the error of an outer row it did not reach
 *    Case 3: a CASE or an OR that keeps a subquery from a row keeps the error of its key away too
 *    Case 4: hierarchical query: the scan of each iteration looks up in key order
 */

drop table if exists hr_n, hr_c, hr_s, hr_o, hr_i, hr_g, hr_gs, hr_t;

create table hr_n (x int);
create table hr_c (id int primary key, g varchar(20));
create table hr_s (id int primary key, k int, s varchar(10));
insert into hr_n select mod(rownum, 50) + 1 from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7}) c;
insert into hr_c select rownum, 'g' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4}) b;
insert into hr_s select rownum, rownum, 's' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4}) b;
create index i_hr_n on hr_n (x);
create index i_hr_s on hr_s (k);
update statistics on hr_n, hr_c, hr_s with fullscan;

evaluate 'Case 1: a join step that remembers its keys, a subquery in the select list; 16 rows a key, 48 rows';
select count(*) from (select /*+ ordered no_merge */ n.x, c.g, (select max(s.s) from hr_s s where s.k = n.x) sq from hr_n n, hr_c c where c.id = n.x and n.x between 1 and 3) t;
select x, g, sq, count(*) from (select /*+ ordered no_merge */ n.x, c.g, (select max(s.s) from hr_s s where s.k = n.x) sq from hr_n n, hr_c c where c.id = n.x and n.x between 1 and 3) t group by x, g, sq order by x;
select count(*) from (select /*+ no_merge */ n.x, c.g, (select max(s.s) from hr_s s where s.k = c.id) sq from hr_n n inner join hr_c c on c.id = n.x where n.x between 10 and 12) t;

create table hr_o (k int primary key);
create table hr_i (id int primary key, k int, pad char(500));
insert into hr_o select rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1}) d;
insert into hr_i select rownum, case when rownum <= 5 then 1 else 100 + mod(rownum, 1900) end, 'p' from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1}) e;
create index i_hr_i on hr_i (k);
update statistics on hr_o, hr_i with fullscan;

evaluate 'Case 2: the outer row k = 2 divides by zero, the statement stops in the rows of k = 1; no error';
select count(*), min(k), max(k) from (select /*+ ordered use_nl */ o.k, i.id from hr_o o, hr_i i where i.pad < 'q' and i.k = o.k and 10 / (o.k - 2) <> 0 limit 3) x;
select count(*) from db_root where exists (select /*+ ordered use_nl */ 1 from hr_o o, hr_i i where i.pad < 'q' and i.k = o.k and 10 / (o.k - 2) <> 0);
select count(*), min(k), max(k) from (select /*+ ordered use_nl */ o.k, i.id from hr_o o, hr_i i where i.pad < 'q' and i.k = o.k and 10 / (o.k - 2) <> 0 and rownum <= 3) x;
evaluate 'Case 2: the same join read to its end; the error of k = 2';
select /*+ ordered use_nl */ count(*) from hr_o o, hr_i i where i.pad < 'q' and i.k = o.k and 10 / (o.k - 2) <> 0;

create table hr_g (id int primary key, k int, flag int, denom int, bad varchar(20), v int);
create table hr_gs (id int primary key, k int, v int);
insert into hr_g values (1, 1, 0, 0, 'not_an_int', 10), (2, 2, 1, 10, '10', 20), (3, 3, 1, 5, '20', 30);
insert into hr_gs values (1, 10, 20), (2, 20, 30);
create index i_hr_g on hr_g (k);
create index i_hr_gs on hr_gs (k);
update statistics on hr_g, hr_gs with fullscan;

evaluate 'Case 3: a CASE or an OR keeps the subquery from the row whose key is an error; no error';
select /*+ recompile ordered use_nl(i) no_parallel_scan */ o.id, i.id, i.denom from hr_g o join hr_g i on i.k = o.k where (case when i.denom <> 0 then (select max(s.v) from hr_gs s where s.k = 100 / i.denom) else 999 end) > 0 order by o.id;
select /*+ recompile ordered use_nl(i) no_parallel_scan */ o.id, i.id, i.bad from hr_g o join hr_g i on i.k = o.k where (case when i.denom <> 0 then (select max(s.v) from hr_gs s where s.k = cast(i.bad as int)) else 999 end) > 0 order by o.id;
select /*+ recompile ordered use_nl(i) no_parallel_scan */ o.id, i.id, o.flag, i.denom from hr_g o join hr_g i on i.k = o.k where (o.flag = 0 or i.v <= (select max(s.v) from hr_gs s where s.k = 100 / i.denom)) order by o.id;
select /*+ recompile ordered use_nl(i) no_parallel_scan */ o.id, i.id, o.flag, i.bad from hr_g o join hr_g i on i.k = o.k where (o.flag = 0 or i.v <= (select max(s.v) from hr_gs s where s.k = cast(i.bad as int))) order by o.id;

create table hr_t (id int primary key, pid int, v varchar(100));
insert into hr_t select rownum, null, repeat('x', 60) || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1}) e;
insert into hr_t select id + 20000, id, repeat('y', 60) || id from hr_t where id <= 20000;
create index i_hr_t on hr_t (pid);
update statistics on hr_t with fullscan;

evaluate 'Case 4: hierarchical query; the scan of each iteration looks up in key order';
set trace on;
select /*+ recompile */ count(*), sum(lv) from (select id, pid, level lv from hr_t start with id between 1 and 4000 connect by prior id = pid) x;
show trace;
set trace off;

drop table hr_n, hr_c, hr_s, hr_o, hr_i, hr_g, hr_gs, hr_t;
