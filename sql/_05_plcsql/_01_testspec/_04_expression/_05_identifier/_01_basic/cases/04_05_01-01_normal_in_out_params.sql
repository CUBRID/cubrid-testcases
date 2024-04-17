--+ server-message on

-- normal: basic usage of in, inout, and out parameters


create or replace procedure t(i int, j in out int, k inout int, l out int) as
    procedure poo(i int, j in out int, k inout int, l out int) as
    begin
        dbms_output.put_line('i=' || i);
        dbms_output.put_line('j=' || j);
        dbms_output.put_line('k=' || k);
        dbms_output.put_line('l is ' || case when l is null then 'null' else '' || l end);

        j := 10 + j;
        k := 10 + k;
        l := 100;

    end;
begin
    dbms_output.put_line('i=' || i);
    dbms_output.put_line('j=' || j);
    dbms_output.put_line('k=' || k);
    dbms_output.put_line('l is ' || case when l is null then 'null' else '' || l end);

    poo(i, j, k, l);

    dbms_output.put_line('i=' || i);
    dbms_output.put_line('j=' || j);
    dbms_output.put_line('k=' || k);
    dbms_output.put_line('l is ' || case when l is null then 'null' else '' || l end);

end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

select 1 into :a from dual;
select 2 into :b from dual;
select 3 into :c from dual;
select 4 into :d from dual;
call t(:a, :b, :c, :d);
select :a, :b, :c, :d from dual;

drop procedure t;


--+ server-message off
