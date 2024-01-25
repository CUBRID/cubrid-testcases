--+ server-message on

-- A test that assigns the result of a comparison function when declaring a constant. 

create or replace procedure t  as
    a constant varchar := COALESCE(5, 10.0000);
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

create or replace procedure t  as
    a constant varchar := DECODE(1, 1, 'one', 2, 'two', 'other');
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

create or replace procedure t  as
    a constant varchar := GREATEST('a', 'b', 'c' );
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

-- IF function is not supported.
select 'IF function is not supported.';
create or replace procedure t  as
    a constant varchar := IF(1=1, 'one', 'other');
begin
    dbms_output.put_line('a = ' || a );
end;
end;


create or replace procedure t  as
    a constant varchar := IFNULL(NULL, 'UNKNOWN');
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

create or replace procedure t  as
    a constant varchar := NVL(NULL, 'NVL call');
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

--bug
select 'bug ISNULL(NULL)';
create or replace procedure t  as
    a constant varchar := ISNULL(NULL);
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

create or replace procedure t  as
    a constant varchar := LEAST('a', 'b', 'c' );
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

--bug
select 'bug NULLIF(NULL, 1), normal:null, bug:0';
create or replace procedure t  as
    a constant varchar := NULLIF(NULL, 1);
begin
    dbms_output.put_line('a = ' || a );
end;
call t();

create or replace procedure t  as
    a constant varchar := NVL2(3, 'NOT NULL', 'NULL');
begin
    dbms_output.put_line('a = ' || a );
end;
call t();



drop procedure t;


--+ server-message off

