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


evaluate 'change procedure owner (dba -> public)';
ALTER procedure test_tbl OWNER TO public;
call public.test_tbl();

evaluate 'ERROR: Stored procedure compile error';
ALTER procedure public.test_tbl OWNER TO dba COMMENT '1: OWNER TO COMMENT';

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';


evaluate 'change table, procedure owner (public -> dba)';
ALTER TABLE public.tbl OWNER TO dba;
evaluate 'add comment of procedure';
ALTER procedure public.test_tbl OWNER TO dba COMMENT '1: OWNER TO COMMENT';

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';


evaluate 'alter comment of procedure';
ALTER procedure test_tbl COMMENT '2: COMMENT';
select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';


drop TABLE tbl;
drop procedure test_tbl;

--+ server-message off
