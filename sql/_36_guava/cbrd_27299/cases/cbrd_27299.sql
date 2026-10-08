/**
 *  This test case verifies CBRD-27299: the PARALLEL_ENABLE option of CREATE FUNCTION,
 *  its catalog columns and the refusals around it.
 *
 *  Before the fix PARALLEL_ENABLE was not a keyword, so CREATE FUNCTION ... PARALLEL_ENABLE
 *  was a syntax error. The fix accepts AUTHID, DETERMINISTIC and PARALLEL_ENABLE in any
 *  order, refuses a repeated option and refuses PARALLEL_ENABLE or DETERMINISTIC on a
 *  procedure. db_stored_procedure and information_schema.routines gain is_parallel_enabled.
 *
 *  Every refusal is shown with its message (CQT server messages), so a generic syntax error
 *  cannot stand in for the specific one. Every accepted declaration is read back from both
 *  views and from _db_stored_procedure.directive (bit 4).
 *
 *  Coverage:
 *    Case 1:  Java FUNCTION with PARALLEL_ENABLE is created and callable
 *    Case 2:  option orders and combinations, directive 0 to 7 in both views
 *    Case 3:  a repeated option is refused with its message, nothing is created
 *    Case 4:  PARALLEL_ENABLE or DETERMINISTIC on a PROCEDURE is refused
 *    Case 5:  only the exact keyword (any case) is the option
 *    Case 6:  CREATE OR REPLACE adds and removes the declaration
 *    Case 7:  return types SET(INT) and CURSOR take the option, a bare SET does not
 *    Case 8:  parallel_enable stays usable as an identifier in SQL
 *    Case 9:  PL/CSQL FUNCTION: stored source and ALTER ... COMPILE keep the option
 *    Case 10: PARALLEL_ENABLE is reserved inside PL/CSQL
 *    Case 11: is_parallel_enabled follows is_deterministic in both views
 */

drop table if exists t_one, parallel_enable;
drop view if exists v_pe;

-- three rows the functions and identifier cases read
create table t_one (a int);
insert into t_one values (1), (2), (3);


evaluate 'Case 1: Java FUNCTION with PARALLEL_ENABLE is created and callable';
create function g_pe(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
select g_pe(a) from t_one order by 1;
select sp_name, sp_type, lang, is_parallel_enabled from db_stored_procedure where sp_name = 'g_pe';
select routine_name, routine_type, is_parallel_enabled from information_schema.routines where routine_name = 'g_pe';


evaluate 'Case 2: option orders and combinations, directive 0 to 7 in both views';
create function g_none(x int) return int as language java name 'SpTest.testInt(int) return int';
create function g_a(x int) return int authid caller as language java name 'SpTest.testInt(int) return int';
create function g_d(x int) return int deterministic as language java name 'SpTest.testInt(int) return int';
create function g_ad(x int) return int authid caller deterministic as language java name 'SpTest.testInt(int) return int';
create function g_da(x int) return int deterministic authid caller as language java name 'SpTest.testInt(int) return int';
create function g_pa(x int) return int parallel_enable authid caller as language java name 'SpTest.testInt(int) return int';
create function g_pd(x int) return int parallel_enable deterministic as language java name 'SpTest.testInt(int) return int';
create function g_dp(x int) return int deterministic parallel_enable as language java name 'SpTest.testInt(int) return int';
create function g_pad(x int) return int parallel_enable authid caller deterministic as language java name 'SpTest.testInt(int) return int';
create function g_apd(x int) return int authid caller parallel_enable deterministic as language java name 'SpTest.testInt(int) return int';
create function g_adp(x int) return int authid caller deterministic parallel_enable as language java name 'SpTest.testInt(int) return int';
create function g_ndp(x int) return int not deterministic parallel_enable as language java name 'SpTest.testInt(int) return int';
select sp_name, authid, is_deterministic, is_parallel_enabled from db_stored_procedure where sp_name like 'g\_%' escape '\' order by 1;
select sp_name, directive from _db_stored_procedure where sp_name like 'g\_%' escape '\' order by 1;
select routine_name, is_deterministic, is_parallel_enabled, security_type, sql_data_access from information_schema.routines where routine_name like 'g\_%' escape '\' order by 1;


evaluate 'Case 3: a repeated option is refused with its message, nothing is created';
--+ server-message on
create function h_pp(x int) return int parallel_enable parallel_enable as language java name 'SpTest.testInt(int) return int';
create function h_aa(x int) return int authid owner authid caller as language java name 'SpTest.testInt(int) return int';
create function h_dd(x int) return int deterministic not deterministic as language java name 'SpTest.testInt(int) return int';
create function h_pdp(x int) return int parallel_enable deterministic parallel_enable as language java name 'SpTest.testInt(int) return int';
create function h_four(x int) return int authid caller deterministic parallel_enable parallel_enable as language java name 'SpTest.testInt(int) return int';
create function h_ada(x int) return int authid owner deterministic authid caller as language java name 'SpTest.testInt(int) return int';
create function h_ppl(n int) return int parallel_enable parallel_enable as begin return n; end;
--+ server-message off
select count(*) from db_stored_procedure where sp_name like 'h\_%' escape '\';


evaluate 'Case 4: PARALLEL_ENABLE or DETERMINISTIC on a PROCEDURE is refused';
--+ server-message on
create procedure p_pe(x int) parallel_enable as language java name 'SpTest5.ptestint1(int)';
create procedure p_det(x int) deterministic as language java name 'SpTest5.ptestint1(int)';
create procedure p_ndet(x int) not deterministic as language java name 'SpTest5.ptestint1(int)';
create procedure p_both(x int) deterministic parallel_enable as language java name 'SpTest5.ptestint1(int)';
create procedure q_pe() parallel_enable as begin null; end;
create procedure q_det() deterministic as begin null; end;
create procedure p_auth(x int) authid caller as language java name 'SpTest5.ptestint1(int)';
--+ server-message off
select sp_name, sp_type, authid, is_deterministic from db_stored_procedure where sp_name like 'p\_%' escape '\' or sp_name like 'q\_%' escape '\' order by 1;


evaluate 'Case 5: only the exact keyword (any case) is the option';
create function k_mc(x int) return int Parallel_Enable as language java name 'SpTest.testInt(int) return int';
--+ server-message on
create function k_lxa(x int) return int parallel_enabled as language java name 'SpTest.testInt(int) return int';
create function k_lxb(x int) return int parallel enable as language java name 'SpTest.testInt(int) return int';
create function k_lxc(x int) return int [parallel_enable] as language java name 'SpTest.testInt(int) return int';
create function k_lxd(x int) return int parallel_enabl as language java name 'SpTest.testInt(int) return int';
--+ server-message off
select sp_name, is_parallel_enabled from db_stored_procedure where sp_name like 'k\_%' escape '\' order by 1;


evaluate 'Case 6: CREATE OR REPLACE adds and removes the declaration';
create or replace function g_pe(x int) return int as language java name 'SpTest.testInt(int) return int';
create or replace function g_none(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
select sp_name, is_parallel_enabled from db_stored_procedure where sp_name in ('g_pe', 'g_none') order by 1;
create or replace function g_pe(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
select sp_name, is_parallel_enabled from db_stored_procedure where sp_name in ('g_pe', 'g_none') order by 1;


evaluate 'Case 7: return types SET(INT) and CURSOR take the option, a bare SET does not';
create function r_set() return set(int) parallel_enable as language java name 'SpTest.testInt10() return int';
create function r_cur() return cursor parallel_enable as language java name 'SpTest.testInt10() return int';
--+ server-message on
create function r_bset() return set parallel_enable as language java name 'SpTest.testInt10() return int';
--+ server-message off
select sp_name, return_type, is_parallel_enabled from db_stored_procedure where sp_name like 'r\_%' escape '\' order by 1;


evaluate 'Case 8: parallel_enable stays usable as an identifier in SQL';
create table parallel_enable (parallel_enable int);
insert into parallel_enable select a from t_one;
select parallel_enable as parallel_enable from parallel_enable order by 1;
create view v_pe (parallel_enable) as select parallel_enable from parallel_enable;
select * from v_pe order by 1;
create function parallel_enable(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
select parallel_enable(parallel_enable) from parallel_enable order by 1;
select is_parallel_enabled from db_stored_procedure where sp_name = 'parallel_enable';


evaluate 'Case 9: PL/CSQL FUNCTION: stored source and ALTER ... COMPILE keep the option';
create function m_pure(n int) return int parallel_enable as begin return n + 1; end;
create function m_ord(n int) return int parallel_enable authid owner deterministic as begin return n; end;
create function m_nd(n int) return int not deterministic parallel_enable as begin return n; end;
create function m_plain(n int) return int as begin return n; end;
select sp_name, lang, authid, is_deterministic, is_parallel_enabled, code from db_stored_procedure where sp_name like 'm\_%' escape '\' order by 1;
alter function m_ord compile;
select m_pure(1), m_ord(5), m_nd(7), m_plain(9);
select sp_name, is_deterministic, is_parallel_enabled from db_stored_procedure where sp_name = 'm_ord';


evaluate 'Case 10: PARALLEL_ENABLE is reserved inside PL/CSQL';
--+ server-message on
create function n_var(n int) return int as parallel_enable int := n; begin return parallel_enable; end;
create function n_par(parallel_enable int) return int as begin return parallel_enable; end;
--+ server-message off
create function n_quoted(n int) return int as "parallel_enable" int := n; begin return "parallel_enable"; end;
select n_quoted(4);
select sp_name from db_stored_procedure where sp_name like 'n\_%' escape '\' order by 1;


evaluate 'Case 11: is_parallel_enabled follows is_deterministic in both views';
select attr_name from db_attribute where class_name = 'db_stored_procedure' and attr_name in ('is_deterministic', 'is_parallel_enabled', 'target') order by def_order;
select attr_name from db_attribute where class_name = 'routines' and attr_name in ('is_deterministic', 'is_parallel_enabled', 'sql_data_access') order by def_order;

drop function g_pe, g_none, g_a, g_d, g_ad, g_da, g_pa, g_pd, g_dp, g_pad, g_apd, g_adp, g_ndp;
drop procedure p_auth;
drop function k_mc, r_set, r_cur, parallel_enable, m_pure, m_ord, m_nd, m_plain, n_quoted;
drop view v_pe;
drop table t_one, parallel_enable;
