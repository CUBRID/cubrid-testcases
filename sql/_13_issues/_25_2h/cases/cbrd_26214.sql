--+ server-message on
-- Verified for CBRD-26214
-- Bug fix: Assertion fails when a commit while an open to cursor on pl/csql

drop table if exists ttt;
create table ttt (i int);
insert into ttt select rownum from db_class a, db_class b, db_class c limit 10000;

create or replace procedure poo as
    cursor c is select /*+ no_parallel_heap_scan */ i from ttt;
    v int;
begin
    open c;
    for k in 1 .. 10000 loop
        fetch c into v;
        if (k mod 2000 = 0) then
            dbms_output.put_line('i value: ' || k);
            commit;
        end if;
    end loop;
    close c;
end;

call poo();

drop procedure poo;
drop ttt;

--+ server-message off

