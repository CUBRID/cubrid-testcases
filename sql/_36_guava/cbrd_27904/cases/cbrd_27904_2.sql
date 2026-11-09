-- CBRD-27904: a view and a trigger condition are stored as text and parsed again. A NULL constant
-- can not be parsed as a condition, so they must keep the original comparison (k = NULL)
-- instead of a folded NULL. A filter index whose condition can never be TRUE is still rejected.

drop view if exists v1, v2, vc;
drop table if exists t2, c2, tr2, tr2_log, f2, f2_copy;

create table t2 (id int primary key, k int);
insert into t2 select rownum, mod (rownum, 20) from db_class a, db_class b limit 200;
insert into t2 values (201, null), (202, null), (203, null), (204, null), (205, null);

-- CREATE VIEW: 0, 190
create view v1 as select * from t2 where not (k = 5 or k = null);
create view v2 as select id, case when not (k = 5 and k = null) then 1 else 0 end c from t2;
select count (*) from v1;
select sum (c) from v2;
-- CREATE OR REPLACE VIEW and ALTER VIEW: 10, 0
create or replace view v1 as select * from t2 where k = 5 or k = null;
select count (*) from v1;
alter view v1 as select * from t2 where k = 5 and k = null;
select count (*) from v1;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v1', 'v2') order by vclass_name;

-- WITH CHECK OPTION: an UNKNOWN condition rejects the row
create table c2 (id int, k int) dont_reuse_oid;
create view vc as select * from c2 where k = 5 or k = null with check option;
insert into vc values (1, 5);
insert into vc values (2, null);
insert into vc values (3, 6);
select * from c2 order by id;

-- AFTER triggers: 0, 190
create table tr2 (id int, k int);
create table tr2_log (id int);
create trigger tr2_or after insert on tr2 if not (obj.k = 5 or obj.k = null) execute insert into tr2_log values (obj.id);
insert into tr2 select id, k from t2;
select count (*) from tr2_log;
drop trigger tr2_or;
delete from tr2;
delete from tr2_log;
create trigger tr2_and after insert on tr2 if not (obj.k = 5 and obj.k = null) execute insert into tr2_log values (obj.id);
insert into tr2 select id, k from t2;
select count (*) from tr2_log;
drop trigger tr2_and;
delete from tr2;
-- BEFORE trigger: only id 1 (k = 5) is rejected
create trigger tr2_bf before insert on tr2 if new.k = 5 or new.k = null execute reject;
insert into tr2 values (1, 5);
insert into tr2 values (2, null);
insert into tr2 values (3, 6);
select * from tr2 order by id;
drop trigger tr2_bf;

-- filter index: a condition that can never be TRUE because of a NULL or FALSE joined by AND is rejected
create table f2 (id int primary key, k int);
insert into f2 select id, k from t2;
create index i_f2_a on f2 (k) where k <> null;
create index i_f2_b on f2 (id) where k > 3 and id < 100 and null = k;
create index i_f2_c on f2 (id) where k > 3 and (id < 100 and k = null);
create index i_f2_d on f2 (id) where k > 3 and id < 100 and 1 = 0;
-- a condition that can be TRUE is kept, and survives CREATE TABLE ... LIKE and ALTER TABLE
create index i_f2_ok on f2 (id) where k > 3 and id < 100;
select index_name, filter_expression from db_index where class_name = 'f2' order by index_name;
create table f2_copy like f2;
select index_name, filter_expression from db_index where class_name = 'f2_copy' order by index_name;
alter table f2 change k k bigint;
select count (*) from f2 where k > 3 and id < 100 using index i_f2_ok;

drop view v1, v2, vc;
drop table t2, c2, tr2, tr2_log, f2, f2_copy;
