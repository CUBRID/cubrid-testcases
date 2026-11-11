/**
 *  This test case verifies CBRD-26470: sql_data_access of package routines is updated when the
 *  package body is created, replaced or dropped.
 *
 *  The routine rows of a package are made when its spec is created. The spec is compiled without
 *  a body, so every routine is NO SQL at that point. Before the fix jsp_create_pkg_body () threw
 *  away the per-routine values of the spec+body compile, and DROP PACKAGE BODY left them as they
 *  were, so a package created spec first kept NO SQL. jsp_set_pkg_sp_sql_data_access () now
 *  updates the routine rows when the body is created, replaced or dropped.
 *
 *  Each check selects sql_data_access of pm, pr, fn from db_stored_procedure and
 *  information_schema.routines (both must agree).
 *
 *  Coverage:
 *    Case 1: spec only: NO SQL. spec then body: MODIFIES / READS / NO SQL
 *    Case 2: CREATE OR REPLACE PACKAGE BODY: all READS SQL DATA, then all NO SQL
 *    Case 3: DROP PACKAGE BODY: all NO SQL
 *    Case 4: body then spec (worked before the fix): MODIFIES / READS / NO SQL
 *    Case 5: the package routine still runs (through a PL/CSQL wrapper) and inserts a row
 */

--+ server-message on

drop table if exists t25;
drop package if exists pk25;
drop package if exists pk25b;
create table t25 (a int);


evaluate 'Case 1: spec only: pm NO SQL. spec then body: pm MODIFIES SQL DATA, pr READS SQL DATA, fn NO SQL';
create package pk25 as procedure pm; procedure pr; function fn return int; end;
select sp_name, sql_data_access from db_stored_procedure where pkg_name = 'pk25' order by 1;
create package body pk25 as procedure pm as begin insert into t25 values (1); end; procedure pr as n int; begin select count(*) into n from t25; end; function fn return int as begin return 1; end; end;
select sp_name, sql_data_access from db_stored_procedure where pkg_name = 'pk25' order by 1;
select specific_name, sql_data_access from information_schema.routines where specific_name like 'pk25.%' order by 1;


evaluate 'Case 2: replaced body with SELECT only: all READS SQL DATA. replaced body without SQL: all NO SQL';
create or replace package body pk25 as procedure pm as n int; begin select count(*) into n from t25; end; procedure pr as n int; begin select count(*) into n from t25; end; function fn return int as n int; begin select count(*) into n from t25; return n; end; end;
select sp_name, sql_data_access from db_stored_procedure where pkg_name = 'pk25' order by 1;
select specific_name, sql_data_access from information_schema.routines where specific_name like 'pk25.%' order by 1;
create or replace package body pk25 as procedure pm as begin null; end; procedure pr as begin null; end; function fn return int as begin return 1; end; end;
select sp_name, sql_data_access from db_stored_procedure where pkg_name = 'pk25' order by 1;
select specific_name, sql_data_access from information_schema.routines where specific_name like 'pk25.%' order by 1;


evaluate 'Case 3: body with INSERT again (pm MODIFIES SQL DATA), then DROP PACKAGE BODY: all NO SQL';
create or replace package body pk25 as procedure pm as begin insert into t25 values (1); end; procedure pr as n int; begin select count(*) into n from t25; end; function fn return int as begin return 1; end; end;
select sql_data_access from db_stored_procedure where pkg_name = 'pk25' and sp_name = 'pm';
drop package body pk25;
select sp_name, sql_data_access from db_stored_procedure where pkg_name = 'pk25' order by 1;
select specific_name, sql_data_access from information_schema.routines where specific_name like 'pk25.%' order by 1;


evaluate 'Case 4: body then spec: pm MODIFIES SQL DATA, pr READS SQL DATA, fn NO SQL';
create package body pk25b as procedure pm as begin insert into t25 values (1); end; procedure pr as n int; begin select count(*) into n from t25; end; function fn return int as begin return 1; end; end;
create package pk25b as procedure pm; procedure pr; function fn return int; end;
select sp_name, sql_data_access from db_stored_procedure where pkg_name = 'pk25b' order by 1;
select specific_name, sql_data_access from information_schema.routines where specific_name like 'pk25b.%' order by 1;


evaluate 'Case 5: pk25b.pm runs through a wrapper and inserts one row';
create or replace procedure w25 as begin pk25b.pm(); end;
call w25();
select count(*) from t25;

drop procedure w25;
drop package pk25;
drop package pk25b;
drop table t25;

--+ server-message off
