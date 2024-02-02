--+ server-message on

-- normal: basic usage of execute immediate with an into clause


create or replace procedure t(i int) as
    charset varchar(32);
begin
    execute immediate 'select charset_name from db_collation where coll_name = ''utf8_en_cs''' into charset;
    dbms_output.put_line('charset=' || charset);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off
