--+ server-message on
-- Verification for CBRD-24708

create or replace function hostvar_test(i_id int, i_name varchar) return varchar as
    s_id int := i_id;
    s_name varchar(10) := i_name;

    id int;
    name varchar;
begin
    id := 0;
    for r in (select charset_id, charset_name from db_charset where charset_id = s_id and charset_name = s_name) loop
        id := r.charset_id;
        name := r.charset_name;
    end loop;

    return id || ', ' || name;
end;

select hostvar_test(5,'utf8') from dual;
select hostvar_test(7,'utf-8') from dual; -- return NULL, because data is not found

drop function hostvar_test;

--+ server-message off
