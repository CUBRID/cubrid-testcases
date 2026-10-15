/*
 * This test case verifies CBRD-27582 : after ALTER TABLE, a prepared UPDATE
 * kept writing the value bound at its first EXECUTE.
 *
 * Bug: a prepared DML statement is compiled again with its host variables
 * bound when its plan cache entry is gone (here: dropped by ALTER TABLE).
 * The XASL generators of UPDATE, DELETE and MERGE translate the SELECT they
 * build once more, and the constant folding replaced the bound host variables
 * by their values (DATE'2024-01-31' + ? -> DATE'2024-02-01', n = 10 + ? ->
 * n = 11). That XASL was cached under the statement text with '?', so every
 * later EXECUTE - and every other statement prepared with the same text -
 * reused the first values: wrong values written, wrong rows updated or
 * deleted, no error.
 *
 * Fix: the SELECT is translated with the host variables unbound, as PREPARE
 * does, so the cached XASL does not depend on the bound values.
 *
 * Every case PREPAREs, runs ALTER TABLE ADD COLUMN to drop the cached plan,
 * then EXECUTEs with different values.
 *   Case 1: UPDATE SET d = DATE'2024-01-31' + ? (1, 2.0, 5)
 *           -> 02/01/2024, 02/02/2024, 02/05/2024 (bug: 02/01/2024 three times)
 *   Case 2: UPDATE SET n = 10 + ? (1, 7) -> 11, 17 (bug: 11, 11)
 *   Case 3: DELETE WHERE n = 10 + ? (1, 7) -> rows 11 and 17 deleted
 *           (bug: the second EXECUTE deleted nothing)
 *   Case 4: UPDATE SET ... WHERE n = 10 + ? (3, 9) -> rows 13 and 19 updated
 *           (bug: row 13 updated twice)
 *   Case 5: MERGE WHEN MATCHED UPDATE SET n = 50 + ? (1, 7) -> 51, 57
 *           (bug: 51, 51)
 *   Case 6: MERGE WHEN NOT MATCHED INSERT VALUES (k, 10 + ?) -> 11, 17, 15
 *   Case 7: a new statement prepared with the text of case 2 after case 2 ran
 *           (it gets the cached plan) -> 15, 18 (bug: 11, 11)
 */

drop table if exists t27582_w, t27582_d, t27582_m, t27582_mi;

evaluate '[1] UPDATE SET d = DATE + ? after ALTER TABLE';
create table t27582_w (id int primary key, d date, n int);
insert into t27582_w values (1, null, 1);
prepare s1 from 'update t27582_w set d = date''2024-01-31'' + ? where id = 1';
alter table t27582_w add column z int;
execute s1 using 1;
select d from t27582_w;
execute s1 using 2.0;
select d from t27582_w;
execute s1 using 5;
select d from t27582_w;
deallocate prepare s1;

evaluate '[2] UPDATE SET n = 10 + ? after ALTER TABLE';
prepare s2 from 'update t27582_w set n = 10 + ? where id = 1';
alter table t27582_w add column z2 int;
execute s2 using 1;
select n from t27582_w;
execute s2 using 7;
select n from t27582_w;
deallocate prepare s2;

evaluate '[3] DELETE WHERE n = 10 + ? after ALTER TABLE';
create table t27582_d (id int, n int);
insert into t27582_d values (1, 11), (2, 17), (3, 13), (4, 19);
prepare s3 from 'delete from t27582_d where n = 10 + ?';
alter table t27582_d add column z int;
execute s3 using 1;
execute s3 using 7;
select id, n from t27582_d order by id;
deallocate prepare s3;

evaluate '[4] UPDATE WHERE n = 10 + ? after ALTER TABLE';
prepare s4 from 'update t27582_d set id = id + 1000 where n = 10 + ?';
alter table t27582_d add column z2 int;
execute s4 using 3;
execute s4 using 9;
select id, n from t27582_d order by id;
deallocate prepare s4;

evaluate '[5] MERGE WHEN MATCHED UPDATE SET n = 50 + ? after ALTER TABLE';
create table t27582_m (id int, n int);
insert into t27582_m values (1, 0);
prepare s5 from 'merge into t27582_m using db_root on (t27582_m.id = 1) when matched then update set n = 50 + ?';
alter table t27582_m add column z int;
execute s5 using 1;
select n from t27582_m;
execute s5 using 7;
select n from t27582_m;
deallocate prepare s5;

evaluate '[6] MERGE WHEN NOT MATCHED INSERT VALUES (k, 10 + ?) after ALTER TABLE';
create table t27582_mi (id int, n int);
prepare s6 from 'merge into t27582_mi using (select ? as k from db_root) s on (t27582_mi.id = s.k) when not matched then insert (id, n) values (s.k, 10 + ?)';
alter table t27582_mi add column z int;
execute s6 using 1, 1;
execute s6 using 2, 7;
execute s6 using 3, 5;
select id, n from t27582_mi order by id;
deallocate prepare s6;

evaluate '[7] a new statement with the same text reuses the cached plan of case 2';
prepare s7 from 'update t27582_w set n = 10 + ? where id = 1';
execute s7 using 5;
select n from t27582_w;
execute s7 using 8;
select n from t27582_w;
deallocate prepare s7;

drop table t27582_w, t27582_d, t27582_m, t27582_mi;
