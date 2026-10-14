-- verified the CBRD-27556
--+ server-message on

evaluate 'index names in index hints of a static SQL (their etc holds a hint kind, not a string)';
create table t1 (c int, d int);
create index i1 on t1 (c);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);

evaluate 'USING INDEX i1(+)';
create or replace procedure p_force as
    n int;
begin
    select count(*) into n from t1 where c > 0 using index i1(+);
    dbms_output.put_line(n);
end;

call p_force();

evaluate 'USING INDEX i1(-)';
create or replace procedure p_ignore as
    n int;
begin
    select count(*) into n from t1 where c > 0 using index i1(-);
    dbms_output.put_line(n);
end;

call p_ignore();

evaluate 'USING INDEX i1, USING INDEX NONE, USING INDEX ALL EXCEPT i1';
create or replace procedure p_use as
    n int;
begin
    select count(*) into n from t1 where c > 0 using index i1;
    dbms_output.put_line(n);
    select count(*) into n from t1 where c > 0 using index none;
    dbms_output.put_line(n);
    select count(*) into n from t1 where c > 0 using index all except i1;
    dbms_output.put_line(n);
end;

call p_use();

evaluate 'an index hint with an alias and a PL/CSQL variable in GROUP BY / HAVING';
create or replace procedure p_force_alias as
    sr sys_refcursor;
    v int := 1;
    a int;
    b int;
begin
    open sr for select c as k, count(*) cnt from t1 where c > 0 group by k having count(*) > v
        using index i1(+);
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_force_alias();

evaluate 'USING INDEX in UPDATE and DELETE';
create or replace procedure p_dml as
    v int := 100;
begin
    update t1 set d = d + 1 where c > v using index i1(+);
    dbms_output.put_line(sql%rowcount);
    delete from t1 where c > v using index i1(-);
    dbms_output.put_line(sql%rowcount);
end;

call p_dml();


drop procedure p_force;
drop procedure p_ignore;
drop procedure p_use;
drop procedure p_force_alias;
drop procedure p_dml;

drop table t1;
