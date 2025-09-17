--+ server-message on
-- Verified for CBRD-26214
-- Bug fix: Assertion fails when a commit while an open to cursor on pl/csql

drop table if exists ttt;
create table ttt (i int);
insert into ttt select rownum from db_class a, db_class b, db_class c limit 10000;



create or replace procedure commit_poo as
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

call commit_poo();

drop procedure commit_poo;



create or replace procedure rollback_poo as
	cursor rc is select /*+ no_parallel_heap_scan */ i from ttt;
    rv int;
begin
    open rc;
    for rk in 1 .. 10000 loop
        fetch rc into rv;
        if (rk mod 2000 = 0) then
            dbms_output.put_line('i value: ' || rk);
            rollback;
        end if;
    end loop;
    close rc;
end;

call rollback_poo();

drop procedure rollback_poo;

drop ttt;

--+ server-message off

