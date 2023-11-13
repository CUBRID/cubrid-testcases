--+ server-message on

-- error: into unupdatable identifiers

create or replace procedure t(charset varchar(32)) as
begin
    execute immediate 'select charset_name from db_collation where coll_name = ''utf8_en_cs''' into charset;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
