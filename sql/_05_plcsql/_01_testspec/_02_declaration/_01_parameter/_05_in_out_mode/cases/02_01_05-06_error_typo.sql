
--+ server-message on

-- Check whether errors occur when writing in, out, and inout statements due to typos.

create or replace procedure t(i on int) as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i in oot int) as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i inoat int) as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i ott int) as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i as int) as
begin
    dbms_output.put_line('i=' || i);
end;



create or replace function t(i on int) return int as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace function t(i in oot int) return int as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace function t(i inoat int) return int as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace function t(i ott int) return int as
begin
    dbms_output.put_line('i=' || i);
end;

create or replace function t(i as int) return int as
begin
    dbms_output.put_line('i=' || i);
end;


--+ server-message off


