--+ server-message on
-- verified the CBRD-25106

CREATE TABLE tbl (col1 int, col2 char(1));
insert into tbl values(1,'a');
insert into tbl values(2,'b');
insert into tbl values(3,'c');
insert into tbl values(4,'d');


create or replace procedure test_tbl as
    cursor c is select col1, col2 from tbl;
begin
    FOR r IN c LOOP
        DBMS_OUTPUT.put_line('col1: ' || r.col1 || '  col2: ' || r.col2);
    END LOOP;
end;

call test_tbl();

evaluate 'change table owner (dba -> public)';
ALTER TABLE tbl OWNER TO public;
evaluate 'ERROR: Stored procedure execute error';
call test_tbl();

evaluate 'ERROR: An object with the supplied attribute value doesnt exist';
ALTER procedure test_tbl OWNER TO no_user;

evaluate 'change procedure owner (dba -> public)';
ALTER procedure test_tbl OWNER TO public;
call public.test_tbl();

evaluate 'ERROR: Stored procedure compile error';
ALTER procedure public.test_tbl OWNER TO dba COMMENT '1: OWNER TO COMMENT';

evaluate 'ERROR: Syntax error';
ALTER procedure public.test_tbl COMMENT '1: OWNER TO COMMENT' OWNER TO dba ;

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';


evaluate 'change table, procedure owner (public -> dba)';
ALTER TABLE public.tbl OWNER TO dba;
evaluate 'add comment of procedure';
ALTER procedure public.test_tbl OWNER TO dba COMMENT '1: OWNER TO COMMENT';

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';


evaluate 'alter comment of procedure';
ALTER procedure test_tbl COMMENT '2: COMMENT';
select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';



evaluate 'check to _db_class on procedure';
evaluate 'create to dba.test_db_class';
create or replace procedure test_db_class as
    cursor c is select unique_name from _db_class where unique_name='dba.tbl';
begin
    FOR r IN c LOOP
        DBMS_OUTPUT.put_line('_db_class result: ' || r.unique_name);
    END LOOP;
end;

call test_db_class();


evaluate 'create to public.test_db_class2, ERROR: Semantic: SELECT is not authorized on _db_class';
create or replace procedure public.test_db_class2 as
    cursor c is select unique_name from _db_class where unique_name='dba.tbl';
begin
    FOR r IN c LOOP
        DBMS_OUTPUT.put_line('_db_class result: ' || r.unique_name);
    END LOOP;
end;


evaluate 'alter owner dba.test_db_class to public, ERROR: Semantic: SELECT is not authorized on _db_class';
ALTER procedure dba.test_db_class OWNER TO public;


evaluate 'grant select on _db_class to public & ALTER procedure dba.test_db_class OWNER TO public';
grant select on _db_class to public;
ALTER procedure dba.test_db_class OWNER TO public;


evaluate 'connect to public & call public.test_db_class()';
call login('public','') on class db_user;
call public.test_db_class();


evaluate 'connect to dba & Test done';
call login('dba','') on class db_user;
revoke select on _db_class from public;
drop TABLE tbl;
drop procedure test_tbl;
drop procedure public.test_db_class;
--+ server-message off
