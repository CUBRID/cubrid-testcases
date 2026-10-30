/**
 *  This test case verifies CBRD-27579: a stored procedure / function invoked inside a SQL statement
 *  may not end the transaction, run DDL or run DML, whatever the table. Reading is allowed.
 *
 *  This file covers a function invoked by INSERT, UPDATE, DELETE and MERGE.
 *
 *  Coverage:
 *    Case 1: DML in a function invoked by INSERT, UPDATE, DELETE, MERGE
 *    Case 2: COMMIT and DDL in a function invoked by UPDATE
 *    Case 3: a function reading the table the statement is changing
 *    Case 4: nothing was written by the functions
 */

--+ server-message on

drop table if exists t;
drop table if exists s;
drop table if exists log_t;
drop table if exists t_new;

create table t (a int, b int);
insert into t values (1, 0), (2, 0), (3, 0);
create table s (a int);
insert into s values (1);
create table log_t (x int);

create or replace function f_dml (n int) return int as begin insert into log_t values (n); return 1; end;
create or replace function f_sel return int as c int; begin select count (*) into c from t; return c; end;
create or replace function f_commit return int as begin commit; return 1; end;
create or replace function f_ddl return int as begin execute immediate 'create table t_new (a int)'; return 1; end;
commit;


evaluate 'Case 1: DML in a function invoked by INSERT, UPDATE, DELETE, MERGE';
insert into log_t values (f_dml (1));
insert into log_t select f_dml (2) from s;
update t set b = f_dml (3);
delete from t where f_dml (4) > 1;
merge into t using s on (t.a = s.a) when matched then update set t.b = f_dml (5);


evaluate 'Case 2: COMMIT and DDL in a function invoked by UPDATE';
update t set b = f_commit ();
update t set b = f_ddl ();


evaluate 'Case 3: a function reading the table the statement is changing';
update t set b = f_sel ();
select a, b from t order by a;


evaluate 'Case 4: nothing was written by the functions';
select count (*) from log_t;
select count (*) from db_class where class_name = 't_new';

--+ server-message off

drop function f_dml;
drop function f_sel;
drop function f_commit;
drop function f_ddl;
drop table t;
drop table s;
drop table log_t;
