-- Verified for CBRD-25352
-- check when same name method and javaSP

evaluate 'create test class with method (method name: dummy_fn)';
create class rectangle(height int) dont_reuse_oid
method dummy_fn(string) string function dummy_fn;
insert into rectangle values (10);
 
select rectangle into :r from rectangle where height=10 order by rectangle;

-- Test only instance method, it is not related CBRD-25352
evaluate 'ERROR: Method "dummy_fn_tmp" not found';
call dummy_fn_tmp(1) on :r;

evaluate 'ERROR: Unresolved method "dummy_fn"';
call dummy_fn(1) on :r;
call dummy_fn(:r, 1);
call dba.dummy_fn(:r, 1);

evaluate 'ERROR: Function dba.dummy_fn is undefined';
select dba.dummy_fn(1) on :r from rectangle;
select dba.dummy_fn(:r, 1) from rectangle;
select dba.dummy_fn(:r, 1) from dual;
-- Test Done
 

evaluate 'Create javaSP (dummy_fn)';
create or replace function dummy_fn(i in int) return int
as language java name 'SpTest.testInt(int) return int' comment 'this is the comment for function f';

select dummy_fn(1) from dual;

evaluate 'if same name as method and javaSP then javaSP is first';
evaluate 'ERROR: Parameter count is invalid. expected: 1, actual: 2';
call dummy_fn(:r, 1);

evaluate 'ERROR: Unresolved method "dummy_fn"';
call dummy_fn(1) on :r;

evaluate 'Result: 2';
select dba.dummy_fn(1) from dual;
select dba.dummy_fn(1) from rectangle;



evaluate 'Test done';
drop table rectangle;
drop function dummy_fn;
