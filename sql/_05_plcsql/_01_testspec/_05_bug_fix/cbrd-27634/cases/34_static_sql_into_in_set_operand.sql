-- verified the CBRD-27634
evaluate 'set operations without INTO in their operands are not affected by the semantic error 344 of a static SQL.';

--+ server-message on

drop table if exists so_t1, so_t2;
create table so_t1 (a int);
create table so_t2 (a int);
insert into so_t1 values (1), (2);
insert into so_t2 values (2), (3);

evaluate 'INTO for the result of a derived table with UNION';
create or replace procedure so_n1 as
    x int;
begin
    select max(a) into x from (select a from so_t1 union select a from so_t2);
    dbms_output.put_line('n1 ' || x);
end;
call so_n1();

evaluate 'INTO for a scalar subquery with UNION';
create or replace procedure so_n2 as
    x int;
begin
    select (select a from so_t1 where a = 1 union select a from so_t2 where a = 9) into x from dual;
    dbms_output.put_line('n2 ' || x);
end;
call so_n2();

evaluate 'FOR loop over UNION';
create or replace procedure so_n3 as
begin
    for r in (select a from so_t1 union select a from so_t2 order by 1) loop
        dbms_output.put_line('n3 ' || r.a);
    end loop;
end;
call so_n3();

evaluate 'cursor with INTERSECT';
create or replace procedure so_n4 as
    cursor c is select a from so_t1 intersect select a from so_t2;
    x int;
begin
    open c;
    fetch c into x;
    dbms_output.put_line('n4 ' || x);
    close c;
end;
call so_n4();

evaluate 'INSERT ... SELECT with EXCEPT';
create or replace procedure so_n5 as
begin
    insert into so_t1 select a from so_t2 except select a from so_t1;
    dbms_output.put_line('n5 ' || sql%rowcount);
end;
call so_n5();
select * from so_t1 order by 1;

evaluate 'a dynamic SQL is not a static SQL';
create or replace procedure so_n6 as
    x int;
begin
    execute immediate 'select a from so_t1 where a = 1 union select a from so_t2 where a = 9' into x;
    dbms_output.put_line('n6 ' || x);
end;
call so_n6();

drop procedure so_n1, so_n2, so_n3, so_n4, so_n5, so_n6;
drop table so_t1, so_t2;

--+ server-message off
