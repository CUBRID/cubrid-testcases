--+ server-message on
-- Verified for CBRD-25005

create or replace procedure poo as s varchar;
begin
    for r in (select coll_id id from db_collation) loop
       select coll_name into s from db_collation where coll_id = r.id;
       dbms_output.put_line('s=' || s);
    end loop;
end;

call poo();

drop procedure poo;

--+ server-message off