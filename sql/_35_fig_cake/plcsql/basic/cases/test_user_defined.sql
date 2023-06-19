--+ server-output on

create or replace procedure demo_hello() as
begin
    DBMS_OUTPUT.put_line('Hello CUBRID PL/CSQL!');
end;

create or replace function demo_hello_ret() return varchar as 
begin
    return 'hello cubrid';
end;

create or replace function demo_global_semantics_udpf() return varchar as
m varchar;
begin
    demo_hello ();
    m := demo_hello_ret ();
    return m;
end;

CALL demo_global_semantics_udpf ();