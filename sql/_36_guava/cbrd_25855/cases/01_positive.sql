-- ============================================
-- CBRD-25855: PL/CSQL OPEN FOR with dynamic SQL and USING clause
-- Positive scenarios (P1-P10)
--   - dynamic SELECT iterated with USING binding (single / multiple / NULL)
--   - empty result, whole-query parameter
--   - dynamic DML applied via EXECUTE IMMEDIATE (with / without USING)
-- ============================================

--+ server-message on

drop table if exists emp;
drop table if exists t_dml;

create table emp (id int primary key, name varchar(20), dept int);
insert into emp values (1,'a',10),(2,'b',10),(3,'c',20);
-- dedicated table for the DML-success checks, kept apart from emp
create table t_dml (id int primary key, dept int);
insert into t_dml values (1,10),(2,20);

-- dynamic table AND column names built into the SQL + a single USING bind
create or replace procedure p_dyn(p_tbl varchar, p_col varchar, p_dept int) as
    c sys_refcursor;
    v_id int;
    v_val varchar(20);
begin
    open c for 'select id, ' || p_col || ' from ' || p_tbl || ' where dept = ? order by id' using p_dept;
    loop
        fetch c into v_id, v_val;
        exit when c%notfound;
        dbms_output.put_line(v_id || ':' || v_val);
    end loop;
    close c;
end;

evaluate 'P1: dynamic table + column names + USING dept=10 -> 1:a, 2:b';
call p_dyn('emp', 'name', 10);

evaluate 'P2: USING dept=20 -> only 3:c (bind re-selects)';
call p_dyn('emp', 'name', 20);

evaluate 'P3: USING dept=99 -> empty result, no error';
call p_dyn('emp', 'name', 99);

-- whole SELECT query passed as a parameter (no USING)
create or replace procedure p_run(p_sql varchar) as
    c sys_refcursor;
    v_id int;
begin
    open c for p_sql;
    loop
        fetch c into v_id;
        exit when c%notfound;
        dbms_output.put_line('value: ' || v_id);
    end loop;
    close c;
end;

evaluate 'P4: whole SELECT query as parameter -> value: 1, value: 2';
call p_run('select id from emp where dept=10 order by id');

-- dynamic DML passed as a parameter, executed via EXECUTE IMMEDIATE
create or replace procedure p_dml(p_sql varchar) as
begin
    execute immediate p_sql;
end;

evaluate 'P5: INSERT via parameter -> t_dml id=9 dept=30';
call p_dml('insert into t_dml(id,dept) values (9,30)');
select dept from t_dml where id=9;

evaluate 'P6: UPDATE via parameter -> t_dml id=1 dept=99';
call p_dml('update t_dml set dept=99 where id=1');
select dept from t_dml where id=1;

evaluate 'P7: DELETE via parameter -> t_dml id=2 removed';
call p_dml('delete from t_dml where id=2');
select count(*) from t_dml where id=2;

-- dynamic DML with host-variable binding via the USING clause
create or replace procedure p_dml_bind(p_sql varchar, p_id int, p_dept int) as
begin
    execute immediate p_sql using p_id, p_dept;
end;

evaluate 'P8: INSERT via parameter with USING bind -> t_dml id=7 dept=70';
call p_dml_bind('insert into t_dml(id,dept) values (?,?)', 7, 70);
select dept from t_dml where id=7;

-- OPEN FOR dynamic SELECT with two USING placeholders bound in order
create or replace procedure p_two(p_lo int, p_hi int) as
    c sys_refcursor;
    v_id int;
begin
    open c for 'select id from emp where id >= ? and id <= ? order by id' using p_lo, p_hi;
    loop
        fetch c into v_id;
        exit when c%notfound;
        dbms_output.put_line('two:' || v_id);
    end loop;
    close c;
end;

evaluate 'P9: two USING placeholders id in [2,3] -> two:2, two:3';
call p_two(2, 3);

-- OPEN FOR with a NULL bind: "id = NULL" is unknown -> matches no rows, no error
create or replace procedure p_nullbind as
    c sys_refcursor;
    v_id int;
    p_null int := null;
begin
    open c for 'select id from emp where id = ?' using p_null;
    loop
        fetch c into v_id;
        exit when c%notfound;
        dbms_output.put_line('n:' || v_id);
    end loop;
    close c;
end;

evaluate 'P10: NULL bind -> no rows, no error';
call p_nullbind();

drop procedure p_dyn;
drop procedure p_run;
drop procedure p_dml;
drop procedure p_dml_bind;
drop procedure p_two;
drop procedure p_nullbind;
drop table if exists emp;
drop table if exists t_dml;

--+ server-message off
