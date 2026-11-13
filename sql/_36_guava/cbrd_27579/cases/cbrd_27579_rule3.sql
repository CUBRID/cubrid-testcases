/**
 *  This test case verifies CBRD-27579 rule 3: a stored procedure / function invoked inside a DML statement
 *  may not write a table that the running statement reads or writes.
 *    - Writing another table is allowed, and reading any table is allowed.
 *    - A view is its base tables, a superclass with ALL includes its subclasses, a partitioned table is all
 *      its partitions, and UPDATE / DELETE include the FK CASCADE children.
 *    - A statement that does not run because its condition is constant false is allowed.
 *
 *  Coverage:
 *    Case 1: writing a table of the statement (INSERT, UPDATE, DELETE, MERGE)
 *    Case 2: writing another table
 *    Case 3: reading a table of the statement
 *    Case 4: static SQL
 *    Case 5: a view, a class hierarchy, a partitioned table and an FK CASCADE child
 *    Case 6: a statement with a constant false condition
 *    Case 7: rows written by the allowed cases only
 */

--+ server-message on

drop view if exists v_t;
drop table if exists t;
drop table if exists s;
drop table if exists log_t;
drop table if exists c_fk;
drop table if exists p_fk;
drop table if exists sub;
drop table if exists sup;
drop table if exists pt;

create table t (a int primary key, b int) dont_reuse_oid;
insert into t values (1, 0), (2, 0), (3, 0);
create table s (a int);
insert into s values (1);
create table log_t (x int);
create view v_t as select a, b from t;
create table p_fk (id int primary key);
insert into p_fk values (1), (2);
create table c_fk (id int, pid int, foreign key (pid) references p_fk (id) on delete cascade);
insert into c_fk values (1, 1);
create table sup (a int, b int);
create table sub under sup;
insert into sup values (1, 0);
insert into sub values (2, 0);
create table pt (a int, b int) partition by range (a) (partition p0 values less than (10), partition p1 values less than maxvalue);
insert into pt values (1, 0), (11, 0);

create or replace function f_exec (q varchar) return int as begin execute immediate q; return 1; end;
create or replace function f_cnt return int as c int; begin select count (*) into c from t; return c; end;
create or replace function f_ins_t return int as begin insert into t values (300, 0); return 1; end;
commit;


evaluate 'Case 1: writing a table of the statement (INSERT, UPDATE, DELETE, MERGE)';
insert into t select a + 10, f_exec ('insert into t values (100, 0)') from s;
insert into log_t select f_exec ('insert into s values (5)') from s;
update t set b = f_exec ('update t set b = 9 where a = 3');
delete from t where a > f_exec ('insert into t values (200, 0)') + 10;
merge into t using s on (t.a = s.a) when matched then update set t.b = f_exec ('delete from s');


evaluate 'Case 2: writing another table';
insert into t select a + 20, f_exec ('insert into log_t values (1)') from s;
update t set b = f_exec ('insert into log_t values (2)') where a = 1;
delete from t where a = 21 and f_exec ('insert into log_t values (3)') = 1;
merge into t using s on (t.a = s.a) when matched then update set t.b = f_exec ('insert into log_t values (4)');


evaluate 'Case 3: reading a table of the statement';
update t set b = f_cnt () where a = 2;
select a, b from t order by a;


evaluate 'Case 4: static SQL';
update t set b = f_ins_t ();


evaluate 'Case 5: a view, a class hierarchy, a partitioned table and an FK CASCADE child';
update v_t set b = f_exec ('insert into t values (400, 0)');
update all sup set b = f_exec ('insert into sub values (3, 0)');
update sub set b = f_exec ('insert into sup values (5, 0)');
update pt set b = f_exec ('insert into pt values (12, 0)') where a = 1;
delete from p_fk where id = f_exec ('insert into c_fk values (2, 2)') + 1;
-- an INSERT does not cascade, so the child is not a table of the statement
insert into p_fk values (f_exec ('insert into c_fk values (3, 1)') + 2);


evaluate 'Case 6: a statement with a constant false condition';
update t set b = f_exec ('delete from t where 1 = 0') where a = 3;


evaluate 'Case 7: rows written by the allowed cases only';
select a, b from t order by a;
select a from s order by a;
select x from log_t order by x;
select a, b from all sup order by a;
select a, b from pt order by a;
select id from p_fk order by id;
select id, pid from c_fk order by id;

--+ server-message off

drop view v_t;
drop function f_exec;
drop function f_cnt;
drop function f_ins_t;
drop table t;
drop table s;
drop table log_t;
drop table c_fk;
drop table p_fk;
drop table sub;
drop table sup;
drop table pt;
