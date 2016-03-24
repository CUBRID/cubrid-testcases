-- create function with comment
create or replace function f(i in number comment 'arg i') return number
as language java name 'SpTest.testInt(int) return int' comment 'this is the comment for function f';

select sp_name, comment from db_stored_procedure;
select sp_name, arg_name, comment from db_stored_procedure_args;


alter function f comment 'new comment for function f';

select sp_name, comment from db_stored_procedure;
select sp_name, arg_name, comment from db_stored_procedure_args;

-- should fail
alter function f;

drop function f;


-- create procedure with comment
create or replace procedure p(i in number comment 'arg i') 
as language java name 'SpTest.testInt(int)'
comment 'this is the comment for procedure p';

select sp_name, comment from db_stored_procedure;
select sp_name, arg_name, comment from db_stored_procedure_args;

alter procedure p comment 'new comment for procedure p';

select sp_name, comment from db_stored_procedure;
select sp_name, arg_name, comment from db_stored_procedure_args;

--should fail
alter procedure p;

drop procedure p;

