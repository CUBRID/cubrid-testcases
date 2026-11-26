-- CBRD-28204: a plan the optimizer gives up on must leave the WHERE whole

evaluate 'Case 1: an UPDATE whose plan the optimizer gives up on still applies every WHERE term: the SELECT counts 2, 2 rows updated, 2 rows changed';
drop table if exists k1;
create table k1 (id int, a int, b int, c varchar(10), d int);
insert into k1 select rownum, mod (rownum, 7), mod (rownum, 13), 'w' || mod (rownum, 20), mod (rownum, 40) from db_class c1, db_class c2 where rownum <= 800;
create index k1_nb on k1 (nvl (b, -1));
create index k1_dc on k1 (d, c);
update statistics on k1 with fullscan;
select count(*) from k1 x where ((x.d <> 36 and x.id = 7) or nvl (x.b, -1) = 12 or (x.d = 36 and lower (x.c) like 'w1%')) and ((x.c is not null and x.d = 42) or (x.b = 3 and not (x.id = -1 or (x.d <> 35 and x.b in (select 99 from db_root))) and x.d >= 36)) and x.d = 36;
update k1 x set x.d = x.d + 1000 where ((x.d <> 36 and x.id = 7) or nvl (x.b, -1) = 12 or (x.d = 36 and lower (x.c) like 'w1%')) and ((x.c is not null and x.d = 42) or (x.b = 3 and not (x.id = -1 or (x.d <> 35 and x.b in (select 99 from db_root))) and x.d >= 36)) and x.d = 36;
select count(*) from k1 where d >= 1000;
drop table k1;

evaluate 'Case 2: a prepared SELECT, UPDATE and DELETE whose host variable goes into a two-column function index expression: 9, 9 rows updated, 9 rows deleted, 791 left';
drop table if exists k2;
create table k2 (id int, a int, b int, d int);
insert into k2 select rownum, mod (rownum, 7), mod (rownum, 13), mod (rownum, 40) from db_class c1, db_class c2 where rownum <= 800;
create index k2_m on k2 (mod (a, b));
create index k2_d on k2 (d);
update statistics on k2 with fullscan;
prepare st from 'select count(*) from k2 x where (mod (x.a, x.b) = 2 or x.id = -5) and x.a = ? and x.d < 40';
execute st using 5;
deallocate prepare st;
prepare st from 'update k2 x set x.d = x.d + 1000 where (mod (x.a, x.b) = 2 or x.id = -5) and x.a = ? and x.d < 40';
execute st using 5;
deallocate prepare st;
select count(*) from k2 where d >= 1000;
prepare st from 'delete from k2 x where (mod (x.a, x.b) = 2 or x.id = -5) and x.a = ? and x.d >= 1000';
execute st using 5;
deallocate prepare st;
select count(*) from k2;
drop table k2;

evaluate 'Case 3: a prepared SELECT whose host variable replaces the only column of a function index expression: 62';
drop table if exists k3;
create table k3 (id int, b int, d int);
insert into k3 select rownum, mod (rownum, 13), mod (rownum, 40) from db_class c1, db_class c2 where rownum <= 800;
create index k3_nb on k3 (nvl (b, -1));
create index k3_d on k3 (d);
update statistics on k3 with fullscan;
prepare st from 'select count(*) from k3 x where (nvl (x.b, -1) = 3 or x.id = -5) and x.b = ? and x.d < 40';
execute st using 3;
deallocate prepare st;
drop table k3;

evaluate 'Case 4: a function index expression after a subquery term keeps its mark and the plan is given up: 1 row, 1 row updated';
drop table if exists k4;
create table k4 (id int, a int, b int, d int);
insert into k4 values (1, 5, 3, 0), (2, 2, 3, 0);
create index k4_m on k4 (mod (a, b));
prepare st from 'select id from k4 x where x.id > (select 0 from db_root) and mod (x.a, x.b) = 2 and x.a = ? order by 1';
execute st using 5;
deallocate prepare st;
prepare st from 'update k4 x set x.d = x.d + 1000 where x.id > (select 0 from db_root) and mod (x.a, x.b) = 2 and x.a = ?';
execute st using 5;
deallocate prepare st;
select id from k4 where d >= 1000 order by 1;
drop table k4;
