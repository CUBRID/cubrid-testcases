/**
 * CBRD-27215 (PR #7658 review, heap_file.c): the index attrinfo (heap_attrinfo_start_with_index ()) decoding
 * columns that are absent from an old representation -- the default-value branch of heap_attrvalue_read () --
 * and NUMERIC defaults of every on-disk size (4/8/12/16/20 bytes) through the fixed-column decode kernel.
 * Expected: identical to develop -- no error, old-representation rows show the defaults.
 */
drop table if exists t_ai;
create table t_ai (id int primary key, k int, s varchar(10));
create index i_t_ai_k on t_ai (k);
insert into t_ai values (1, 10, 'a'), (2, 20, 'b'), (3, 30, 'c'), (4, 40, 'd');

-- new representation: NUMERIC defaults spanning the 4/8/12/16/20-byte disk sizes, then indexes on them
alter table t_ai add column n1 numeric(1,0) default 9;
alter table t_ai add column n2 numeric(10,2) default -12345.67;
alter table t_ai add column n3 numeric(20,5) default 123456789012345.12345;
alter table t_ai add column n4 numeric(30,0) default 123456789012345678901234567890;
alter table t_ai add column n5 numeric(38,0) default 99999999999999999999999999999999999999;
alter table t_ai add column n6 numeric(38,0) default -99999999999999999999999999999999999999;
create index i_t_ai_n1 on t_ai (n1);
create index i_t_ai_n2 on t_ai (n2);
create index i_t_ai_n5 on t_ai (n5);
create unique index u_t_ai_n4_id on t_ai (n4, id);

-- rows still in the old representation: index maintenance reads n1..n6 through the default-value branch
select id, k, n1, n2, n3, n4, n5, n6 from t_ai order by id;
update t_ai set k = k + 1 where id = 2;
update t_ai set s = 'zz' where k = 31;
delete from t_ai where id = 3;
insert into t_ai (id, k, s) values (5, 50, 'e');
insert into t_ai values (6, 60, 'f', 1, 0.5, 1.00001, 1, 1, -1);
-- REPLACE / ON DUPLICATE KEY UPDATE use query_executor.c's own index attrinfo (qexec_execute_insert, L13144)
replace into t_ai (id, k, s) values (1, 11, 'r');
insert into t_ai (id, k, s) values (4, 44, 'o') on duplicate key update k = k + 100;
select id, k, s, n1, n2, n3, n4, n5, n6 from t_ai order by id;
select id, n1 from t_ai where n1 = 9 order by id;
select id, n2 from t_ai where n2 < 0 order by id;
select id, n5 from t_ai where n5 = 99999999999999999999999999999999999999 order by id;
select count(*), sum(n4), min(n6), max(n5) from t_ai;
-- old- and new-representation rows in one scan: the decoding plan is re-derived on every representation switch
update t_ai set n2 = n2 + 1 where id in (1, 5);
select id, n2 from t_ai order by id;
drop table t_ai;

