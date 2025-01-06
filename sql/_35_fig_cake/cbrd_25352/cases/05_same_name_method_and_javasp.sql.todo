-- Verified for CBRD-25352
-- check when same name method and javaSP

evaluate 'create test class with method (method name: set_cost)';
create class rectangle(height int, width int) dont_reuse_oid
method set_cost(string, string) string function qo_set_cost;
insert into rectangle values (10, 10);
 
select rectangle into :r from rectangle where height=10 order by rectangle;


evaluate 'call set_cost(method)';
call set_cost('nl-join', 0) on :r;
 
select set_cost(r, 'nl-join', '0') from rectangle r;
select 11, set_cost(r, 'nl-join', '0'), 'aaa' from rectangle r ;

evaluate 'ERROR: Function dba.set_cost is undefined';
select 11, dba.set_cost(r, 'nl-join', '0'), 'aaa' from rectangle r;


evaluate 'create test function (sp name: set_cost)';
create or replace function set_cost(i in int) return int
as language java name 'SpTest.testInt(int) return int' comment 'this is the comment for function f';



evaluate 'call instance method (set_cost)';
call set_cost('nl-join', 0) on :r;

evaluate 'ERROR: Unknown variable rr';
call set_cost('nl-join', 0) on :rr;

evaluate 'ERROR: Stored procedure execute error: Argument count mismatch: expected 1, but 3';
select set_cost(rr, 'nl-join', '0') from rectangle rr;



evaluate 'call javasp (set_cost)';
select set_cost(1) from rectangle rr;

evaluate 'ERROR: Stored procedure execute error: Argument count mismatch: expected 1, but 3';
select 11, dba.set_cost(rr, 'nl-join', '0'), 'aa' from rectangle rr;

evaluate 'call javasp (dba.set_cost)';
select dba.set_cost(1) from rectangle rr;



evaluate 'Test done';
CALL login(CLASS db_user, 'dba', '');
drop table rectangle;
drop function set_cost;
