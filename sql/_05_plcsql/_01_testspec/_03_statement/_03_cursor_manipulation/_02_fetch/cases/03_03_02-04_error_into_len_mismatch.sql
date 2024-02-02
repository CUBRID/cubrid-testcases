--+ server-message on

-- error: into clause length mismatch

create or replace procedure t(i int) as
    cursor c(cs varchar(32), b int) is select coll_name from db_collation where charset_name = cs and coll_id > b;
    r varchar(32);
    rr varchar(32);
begin
    open c('utf8', 3);
    fetch c into r, rr;
end;


select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';



--+ server-message off
