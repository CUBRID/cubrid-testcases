--+ server-message on

-- error: into clause type mismatch

create or replace procedure t(i int) as
    cursor c(cs varchar(32), b int) is select coll_name from db_collation where charset_name = cs and coll_id > b;
    b boolean;
begin
    open c('utf8', 3);
    fetch c into b;
end;


select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


