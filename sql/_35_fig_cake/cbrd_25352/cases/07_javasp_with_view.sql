-- Verified for CBRD-25352
-- Create view with javasp

evaluate 'create javasp & view';
CREATE FUNCTION hello(name varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(java.lang.String) return java.lang.String';


evaluate 'ERROR: Syntax error: unexpected call';
create view v_method1 as call add_user('test_user') on class db_user;


evaluate 'ERROR: Missing an expected attribute name';
create view v_method2 as select hello('cubrid');


evaluate 'success: v_method3';
create view v_method3 as select hello('cubrid') h3;
select * from v_method3;


evaluate 'success: v_method4';
create view v_method4 (h4 varchar) as select hello('cubrid');
select * from v_method4;


evaluate 'ERROR: Missing an expected attribute name';
create view v_method5 as select dba.hello('cubrid');


evaluate 'ERROR: public.hello() is not defined';
create view v_method6 as select public.hello('cubrid') h;


evaluate 'success: v_method7';
create view v_method7 as select dba.hello('cubrid') h7;
select * from v_method7;


evaluate 'success: v_method8';
create view v_method8 (h8 varchar) as select dba.hello('cubrid');
select * from v_method8;


evaluate 'success: v_method9';
create view v_method9 as select hello('cubrid') as "dual" from dual;
select * from v_method9;


evaluate 'success: v_method10';
create view v_method10 (h10 varchar) as select hello('cubrid') as "dual" from dual;
select * from v_method10;

evaluate 'success: v_method11';
create view v_method11 (h11 varchar) as select dba.hello('cubrid') as "dual" from dual;
select * from v_method11;


select class_of.unique_name, spec from _db_query_spec where class_of.unique_name like '%v_method%' order by class_of.unique_name;


evaluate 'Test done (expected: 1, 2, 5, 6 is not exists)';
drop view v_method1;
drop view v_method2;
drop view v_method3;
drop view v_method4;
drop view v_method5;
drop view v_method6;
drop view v_method7;
drop view v_method8;
drop view v_method9;
drop view v_method10;
drop view v_method11;
drop function hello;
