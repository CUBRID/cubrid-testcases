--+ server-message on

-- normal: basic usage of execute immediate with a using clause


create or replace procedure poo(a int, b IN int, c IN OUT int, d INOUT int, e OUT int) as
begin
    dbms_output.put_line('a=' || a);
    dbms_output.put_line('b=' || b);
    dbms_output.put_line('c=' || c);
    dbms_output.put_line('d=' || d);
    dbms_output.put_line('e is ' || case when e is null then 'null' else 'non-null' end);
    c := 33;
    d := 44;
    e := 55;
end;

create or replace procedure t(i int) as
    a int := 1;
    b int := 2;
    c int := 3;
    d int := 4;
    e int := 5;
begin
    execute immediate 'call poo(?, ?, ?, ?, ?)' using a, IN b, IN OUT c, INOUT d, OUT e;
    dbms_output.put_line('a=' || a);
    dbms_output.put_line('b=' || b);
    dbms_output.put_line('c=' || c);
    dbms_output.put_line('d=' || d);
    dbms_output.put_line('e=' || e);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;
drop procedure poo;


