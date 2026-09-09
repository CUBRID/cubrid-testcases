/*
 * CBRD-27374: when the length of the select list of a SYS_REFCURSOR cursor is
 * checked, what the cursor remembers of it, and what state is left when the
 * check fails. 01_count.sql covers what is compared with what.
 *
 * The check reads the meta data of the prepared statement before the row is
 * read, keeps the length until the cursor is closed, and reports a mismatch as
 * an ordinary PL/CSQL exception, so the cursor stays usable after it is caught.
 *
 * E3 is the clearest difference in behavior: before the fix the mismatched
 * FETCH silently consumed a row, so the retry returned the second row, and
 * there was no exception to catch.
 */

--+ server-message on

drop table if exists t27374s;
drop table if exists t27374s_alt;

create table t27374s (code int primary key, name varchar(40));
insert into t27374s values (10001, 'kim'), (10002, 'lee');

-- only E4 uses this table, which it alters, so that the column count the other
-- scenarios see is not disturbed. It is the only table here that needs a third
-- column, because E4 is the only scenario that selects every column.
create table t27374s_alt (code int primary key, name varchar(40), gender char(1));
insert into t27374s_alt values (10001, 'kim', 'M');

evaluate 'E1: the length is read before the row is, so an empty result set is a mismatch';
create or replace procedure p27374s_empty as
    rc sys_refcursor;
    vcode int;
begin
    open rc for 'select code, name from t27374s where 1 = 0';
    fetch rc into vcode;
    close rc;
end;
call p27374s_empty();

evaluate 'E2: the length is kept while the cursor is open, after the first fetch produced its row';
create or replace procedure p27374s_two_fetch as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for 'select code, name from t27374s order by code';
    fetch rc into vcode, vname;
    dbms_output.put_line(vcode || ' ' || vname);
    fetch rc into vcode;
    close rc;
end;
call p27374s_two_fetch();

evaluate 'E3: the mismatch is a catchable exception and the failed check consumed no row';
create or replace procedure p27374s_catch as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for 'select code, name from t27374s order by code';
    begin
        fetch rc into vcode;
    exception when others then
        dbms_output.put_line('caught: ' || sqlerrm);
    end;
    fetch rc into vcode, vname;
    dbms_output.put_line('after: ' || vcode || ' ' || vname);
    close rc;
end;
call p27374s_catch();

evaluate 'E4: the length follows the statement, not the source -- before the table gains a column';
create or replace procedure p27374s_alter as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
    vgender char(1);
begin
    open rc for 'select * from t27374s_alt order by code';
    fetch rc into vcode, vname, vgender;
    dbms_output.put_line(vcode || ' ' || vname || ' ' || vgender);
    close rc;
end;
call p27374s_alter();

alter table t27374s_alt add column nation varchar(10);

evaluate 'E4: the same procedure, not recompiled, now reports a mismatch of (4)';
call p27374s_alter();

evaluate 'E5: a cursor opened and closed on every iteration prepares its own statement each time';
create or replace procedure p27374s_loop_open as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
    i int := 0;
begin
    while i < 3 loop
        i := i + 1;
        open rc for 'select code, name from t27374s order by code';
        fetch rc into vcode, vname;
        dbms_output.put_line(i || ': ' || vcode || ' ' || vname);
        close rc;
    end loop;
end;
call p27374s_loop_open();

-- the length is the column count of the result set and not a count of the
-- tables or of the expressions written in the source
create or replace procedure p27374s_shape(p_kind int) as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    if p_kind = 1 then
        open rc for 'select code from t27374s union select code from t27374s';
    elsif p_kind = 2 then
        open rc for 'select count(*), max(name) from t27374s';
    else
        open rc for 'select 1, ''a'', 3';
    end if;
    fetch rc into vcode, vname;
    dbms_output.put_line('fetched ' || vcode || ' ' || vname);
    close rc;
end;

evaluate 'E6: a UNION of two one column queries is (1)';
call p27374s_shape(1);

evaluate 'E6: an aggregate query without GROUP BY is (2)';
call p27374s_shape(2);

evaluate 'E6: a select list of literals without a FROM clause is (3)';
call p27374s_shape(3);

evaluate 'E7: a static SELECT that reads a PL/CSQL variable binds values and is checked the same way';
create or replace procedure p27374s_static_hv(p_min int) as
    rc sys_refcursor;
    vcode int;
begin
    open rc for select code, name from t27374s where code >= p_min order by code;
    fetch rc into vcode;
    close rc;
end;
call p27374s_static_hv(10001);

-- clean up the shared database
drop procedure p27374s_empty;
drop procedure p27374s_two_fetch;
drop procedure p27374s_catch;
drop procedure p27374s_alter;
drop procedure p27374s_loop_open;
drop procedure p27374s_shape;
drop procedure p27374s_static_hv;
drop table if exists t27374s;
drop table if exists t27374s_alt;

--+ server-message off
