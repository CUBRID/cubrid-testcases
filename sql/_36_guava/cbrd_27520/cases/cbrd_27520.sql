/**
 *  This test case verifies CBRD-27520: <table>.<column>%TYPE in the parameter or return
 *  types of a PL/CSQL SP must refer to the table of the SP owner when the table name is
 *  not qualified, even when the SP owner is not the current user.
 *
 *  Before the fix (engine PR #8093), an unqualified table name in %TYPE was qualified with
 *  the current user, so CREATE PROCEDURE adam.p1(i tbl.i%type) run by dba failed with
 *  "Table column 'dba.tbl.i' has not been defined" although adam.tbl exists. The PL/CSQL
 *  compiler, which runs as the SP owner, resolves the name as adam.tbl, so the semantic
 *  check and the compiler looked at different tables.
 *
 *  Coverage:
 *    Case 1:  parameter type, return type, and both, with unqualified table names (the reported case)
 *    Case 2:  table name qualified with its owner
 *    Case 3:  system class (an owner is never added to it)
 *    Case 4:  table existing only in the schema of the current user: must fail
 *    Case 5:  table of another user, qualified with its owner
 *    Case 6:  SP name without an owner (owned by the current user)
 *    Case 7:  the owner creates its own SP
 *    Case 8:  tables of the same name for dba and adam, with different column types:
 *             the types of adam.tbl must be used
 *    Case 9:  call the SPs and check the stored parameter and return types
 */

call login('dba', '') on class db_user;
drop table if exists tbl, only_dba, t_dba;

create user adam;
create table adam.tbl (i int, s varchar(20));
create table only_dba (i int);
create table t_dba (d double);
grant select on t_dba to adam;

evaluate 'Case 1: unqualified table names in %TYPE refer to adam.tbl';
create or replace procedure adam.p1(i tbl.i%type) as begin null; end;
create or replace function adam.f2(x int) return tbl.s%type as begin return 'v' || x; end;
create or replace function adam.f3(a tbl.i%type, b tbl.s%type) return tbl.i%type as begin return a + length(b); end;

evaluate 'Case 2: table name qualified with its owner';
create or replace procedure adam.p4(i adam.tbl.i%type) as begin null; end;

evaluate 'Case 3: system class';
create or replace procedure adam.p5(n db_class.class_name%type) as begin null; end;

evaluate 'Case 4: only dba.only_dba exists. adam.only_dba does not, so this must fail.';
create or replace procedure adam.p6(i only_dba.i%type) as begin null; end;

evaluate 'Case 5: table of another user, qualified with its owner';
create or replace procedure adam.p7(d dba.t_dba.d%type) as begin null; end;

evaluate 'Case 6: SP name without an owner';
create or replace procedure p8(d t_dba.d%type) as begin null; end;

evaluate 'Case 7: the owner creates its own SP';
call login('adam', '') on class db_user;
create or replace procedure p11(i tbl.i%type) as begin null; end;
create or replace procedure adam.p12(i tbl.i%type) as begin null; end;
call login('dba', '') on class db_user;

evaluate 'Case 8: dba.tbl has the same name as adam.tbl but different column types. The types of adam.tbl (int, varchar) must be used.';
create table tbl (i varchar(10), s double);
create or replace function adam.f9(a tbl.i%type) return tbl.s%type as begin return 'a' || a; end;

evaluate 'Case 9: call the SPs and check the stored types';
call adam.p1(10);
select adam.f2(5), adam.f3(1, 'abc'), adam.f9(7);

select sp_name, owner.name, return_type
  from _db_stored_procedure
 where owner.name in ('ADAM', 'DBA') and sp_name in ('p1', 'f2', 'f3', 'p4', 'p5', 'p6', 'p7', 'p8', 'f9', 'p11', 'p12')
 order by 2, 1;

select sp_of.sp_name, arg_name, data_type
  from _db_stored_procedure_args
 where sp_of.owner.name in ('ADAM', 'DBA') and sp_of.sp_name in ('p1', 'f2', 'f3', 'p4', 'p5', 'p6', 'p7', 'p8', 'f9', 'p11', 'p12')
 order by 1, 2;

drop procedure adam.p1, adam.p4, adam.p5, adam.p7, adam.p11, adam.p12, p8;
drop function adam.f2, adam.f3, adam.f9;
drop table adam.tbl, tbl, only_dba, t_dba;
drop user adam;
