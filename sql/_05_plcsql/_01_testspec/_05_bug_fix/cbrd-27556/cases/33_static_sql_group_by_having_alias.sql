-- verified the CBRD-27556
evaluate 'an alias of the select list in GROUP BY / HAVING of a static SQL.';
evaluate 'a name in GROUP BY / HAVING / ORDER BY is resolved in the order of a column, an alias and a PL/CSQL variable.';

--+ server-message on

drop table if exists t1, t2;
create table t1 (c int, d int);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);
create table t2 (c int);
insert into t2 values (1), (2);

evaluate 'alias in GROUP BY';
create or replace procedure p_g01 as
    sr sys_refcursor;
    a int;
    b int;
begin
    open sr for select c as k, count(*) from t1 group by k order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g01();

evaluate 'alias in HAVING';
create or replace procedure p_g02 as
    sr sys_refcursor;
    a int;
    b int;
begin
    open sr for select c as k, count(*) cnt from t1 group by c having k > 1 order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g02();

evaluate 'alias in ORDER BY (resolved by the parser)';
create or replace procedure p_g03 as
    sr sys_refcursor;
    a int;
begin
    open sr for select c as k from t1 order by k desc;
    loop
        fetch sr into a;
        exit when sr%notfound;
        dbms_output.put_line(a);
    end loop;
    close sr;
end;

call p_g03();

evaluate 'a column with the same name as an alias wins: grouped by t1.c (3 groups), not by d (4 groups)';
create or replace procedure p_g04 as
    sr sys_refcursor;
    a int;
    b int;
begin
    open sr for select min(d) as c, count(*) cnt from t1 group by c order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g04();

evaluate 'an alias wins over a PL/CSQL variable with the same name: 2 rows (alias), not 0 rows (k = 1)';
create or replace procedure p_g05 as
    sr sys_refcursor;
    a int;
    b int;
    k int := 1;
begin
    open sr for select c as k, count(*) cnt from t1 group by c having k > 1 order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g05();

evaluate 'alias of an expression with a PL/CSQL variable';
create or replace procedure p_g06(p int) as
    sr sys_refcursor;
    a int;
    b int;
begin
    open sr for select c + p as k, count(*) from t1 group by k having k > p + 1 order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g06(10);

evaluate 'PL/CSQL variable in a GROUP BY expression';
create or replace procedure p_g11 as
    sr sys_refcursor;
    a int;
    b int;
    p int := 10;
begin
    open sr for select c + p, count(*) from t1 group by c + p order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g11();

evaluate 'PL/CSQL variable as an argument of HAVING';
create or replace procedure p_g12 as
    sr sys_refcursor;
    a int;
    b int;
    p int := 1;
begin
    open sr for select c, count(*) from t1 group by c having c > p order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g12();

evaluate 'PL/CSQL variable in a function of HAVING';
create or replace procedure p_g13 as
    sr sys_refcursor;
    a int;
    b int;
    p int := -1;
begin
    open sr for select c, count(*) from t1 group by c having count(*) > abs(p) order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g13();

evaluate 'PL/CSQL variable in a subquery of HAVING';
create or replace procedure p_g14 as
    sr sys_refcursor;
    a int;
    b int;
    p int := 2;
begin
    open sr for select c, count(*) from t1 group by c having c > (select min(t2.c) from t2 where t2.c >= p) order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g14();

evaluate 'PL/CSQL variable in an ORDER BY expression';
create or replace procedure p_g15 as
    sr sys_refcursor;
    a int;
    b int;
    p int := -1;
begin
    open sr for select c, c * p from t1 order by c * p;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a);
    end loop;
    close sr;
end;

call p_g15();

evaluate 'rec.field in HAVING';
create or replace procedure p_g16 as
    sr sys_refcursor;
    a int;
    b int;
    r t1%rowtype;
begin
    select * into r from t1 where c = 3;
    open sr for select c, count(*) from t1 group by c having c < r.c order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g16();

evaluate 'PL/CSQL variables in the select list, WHERE, HAVING and LIMIT';
create or replace procedure p_g21 as
    sr sys_refcursor;
    a int;
    b int;
    p1 int := 2;
    p2 int := 1;
    p3 int := 10;
    lim int := 1;
begin
    open sr for select c * p3, count(*) from t1 where c >= p1 group by c having count(*) >= p2 limit lim;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g21();

evaluate 'alias and PL/CSQL variable in GROUP BY, HAVING and ORDER BY';
create or replace procedure p_g22 as
    sr sys_refcursor;
    a int;
    b int;
    p int := 2;
begin
    open sr for select c as k, count(*) cnt from t1 group by k having k >= p order by k desc;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g22();

evaluate 'alias in GROUP BY of a subquery in HAVING';
create or replace procedure p_g23(p int) as
    sr sys_refcursor;
    a int;
    b int;
begin
    open sr for select c, count(*) from t1 group by c having c in (select c as k from t2 group by k having k >= p) order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_g23(2);

evaluate 'alias in SELECT INTO';
create or replace procedure p_select_into as
    a int;
    b int;
begin
    select c as k, count(*) into a, b from t1 group by k having k = 2;
    dbms_output.put_line(a || ':' || b);
end;

call p_select_into();

evaluate 'alias in a cursor declaration with a parameter, FOR loop';
create or replace procedure p_cursor_for_loop as
    cursor cur(p int) is select c as k, count(*) cnt from t1 group by k having k >= p order by 1;
begin
    for r in cur(2) loop
        dbms_output.put_line(r.k || ':' || r.cnt);
    end loop;
end;

call p_cursor_for_loop();

evaluate 'alias in a subquery of DELETE';
create or replace procedure p_delete as
    n int;
begin
    delete from t2 where c in (select c as k from t1 group by k having count(*) > 1);
    select count(*) into n from t2;
    dbms_output.put_line(n);
end;

call p_delete();

evaluate 'the same aliases out of PL/CSQL';
select c as k, count(*) from t1 group by k order by 1;
select c as k, count(*) cnt from t1 group by c having k > 1 order by 1;
select min(d) as c, count(*) from t1 group by c order by 1;
select c as k, d, count(*) from t1 group by k, d order by 1, 2;


drop procedure p_g01;
drop procedure p_g02;
drop procedure p_g03;
drop procedure p_g04;
drop procedure p_g05;
drop procedure p_g06;
drop procedure p_g11;
drop procedure p_g12;
drop procedure p_g13;
drop procedure p_g14;
drop procedure p_g15;
drop procedure p_g16;
drop procedure p_g21;
drop procedure p_g22;
drop procedure p_g23;
drop procedure p_select_into;
drop procedure p_cursor_for_loop;
drop procedure p_delete;

drop table t1, t2;

--+ server-message off
