/*
 * CBRD-27374: the length of the select list of a SYS_REFCURSOR cursor opened by
 * OPEN FOR is checked at run time, at every FETCH, against the number of
 * variables in the INTO clause. A mismatch in either direction raises an error.
 *
 * The check cannot be a compile-time one: with dynamic SQL the query is a
 * string, and even with static SQL the statement a SYS_REFCURSOR holds is
 * decided by the control flow. An ordinary cursor declared with a static SELECT
 * keeps its compile-time check instead.
 *
 * This file covers what is compared with what. 02_state.sql covers when the
 * check runs and what it leaves behind.
 *
 * Before the fix a mismatch was not reported: extra select list columns were
 * silently dropped, and extra INTO variables ended in an unrelated "Missing or
 * invalid position of the bind variable provided." error.
 */

--+ server-message on

drop table if exists t27374;

-- three columns, so that "select *" gives a length of (3) that no case below
-- matches by accident
create table t27374 (code int primary key, name varchar(40), gender char(1));
insert into t27374 values (10001, 'kim', 'M'), (10002, 'lee', 'W');

-- ----------------------------------------------------------------------------
-- D group: the cursor is opened with dynamic SQL, so the select list length is
-- unknown until the statement is prepared at run time.
-- ----------------------------------------------------------------------------

evaluate 'D1: dynamic, select list (2) into one variable -- the report of the issue';
create or replace procedure p27374_d_short as
    rc sys_refcursor;
    vcode int;
begin
    open rc for 'select code, name from t27374';
    fetch rc into vcode;
    close rc;
end;
call p27374_d_short();

evaluate 'D2: dynamic, select list (2) into three variables -- the Additional Information';
create or replace procedure p27374_d_long as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
    vdummy int;
begin
    open rc for 'select code, name from t27374';
    fetch rc into vcode, vname, vdummy;
    close rc;
end;
call p27374_d_long();

evaluate 'D3: dynamic, the counts match -- the fetch must still return the row';
create or replace procedure p27374_d_match as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for 'select code, name from t27374 order by code';
    fetch rc into vcode, vname;
    dbms_output.put_line(vcode || ' ' || vname);
    close rc;
end;
call p27374_d_match();

evaluate 'D4: dynamic, "select *" is counted from the prepared statement, so (3)';
create or replace procedure p27374_d_star as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for 'select * from t27374';
    fetch rc into vcode, vname;
    close rc;
end;
call p27374_d_star();

evaluate 'D5: dynamic with a USING clause is checked the same way';
create or replace procedure p27374_d_using(p_min int) as
    rc sys_refcursor;
    vcode int;
begin
    open rc for 'select code, name from t27374 where code >= ?' using p_min;
    fetch rc into vcode;
    close rc;
end;
call p27374_d_using(10001);

-- ----------------------------------------------------------------------------
-- S group: the cursor is a SYS_REFCURSOR opened with static SQL. The check that
-- is emitted is chosen by the cursor being a SYS_REFCURSOR and not by the SQL
-- being dynamic, so the counting itself is left to the D group and only the two
-- ends of it are repeated here.
-- ----------------------------------------------------------------------------

evaluate 'S1: static, select list (2) into one variable';
create or replace procedure p27374_s_short as
    rc sys_refcursor;
    vcode int;
begin
    open rc for select code, name from t27374;
    fetch rc into vcode;
    close rc;
end;
call p27374_s_short();

evaluate 'S2: static, the counts match';
create or replace procedure p27374_s_match as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for select code, name from t27374 order by code;
    fetch rc into vcode, vname;
    dbms_output.put_line(vcode || ' ' || vname);
    close rc;
end;
call p27374_s_match();

-- ----------------------------------------------------------------------------
-- C group: an ordinary cursor declared with a static SELECT is unchanged -- the
-- length check stays a compile-time one, with its own message.
-- ----------------------------------------------------------------------------

evaluate 'C1: declared cursor, mismatch is rejected while the procedure is created';
create or replace procedure p27374_c_short as
    cursor cur is select code, name from t27374;
    vcode int;
begin
    open cur;
    fetch cur into vcode;
    close cur;
end;

evaluate 'C2: declared cursor with matching counts still compiles and runs';
create or replace procedure p27374_c_match as
    cursor cur is select code, name from t27374 order by code;
    vcode int;
    vname varchar(40);
begin
    open cur;
    fetch cur into vcode, vname;
    dbms_output.put_line(vcode || ' ' || vname);
    close cur;
end;
call p27374_c_match();

-- ----------------------------------------------------------------------------
-- R group: the length the cursor remembers, and the order of the run-time checks
-- ----------------------------------------------------------------------------

evaluate 'R1: the remembered length is dropped on CLOSE, so the cursor can be reopened for another length';
create or replace procedure p27374_reopen as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for select code, name from t27374 order by code;
    fetch rc into vcode, vname;
    dbms_output.put_line(vcode || ' ' || vname);
    close rc;

    open rc for 'select code from t27374 order by code desc';
    fetch rc into vcode;
    dbms_output.put_line(vcode);
    close rc;
end;
call p27374_reopen();

evaluate 'R2: reading the length of a closed cursor is an invalid cursor error, not a mismatch';
create or replace procedure p27374_closed as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for select code, name from t27374;
    close rc;
    fetch rc into vcode, vname;
end;
call p27374_closed();

evaluate 'R3: the NULL check comes first, so a cursor never opened reports being NULL';
create or replace procedure p27374_null as
    rc sys_refcursor;
    vcode int;
begin
    fetch rc into vcode;
end;
call p27374_null();

-- ----------------------------------------------------------------------------
-- M group: a %ROWTYPE record is expanded into its fields before the count is
-- taken, so the fields of the record are what the select list is compared against
-- ----------------------------------------------------------------------------

evaluate 'M1: the record has as many fields as the select list has columns';
create or replace procedure p27374_rec_match as
    rc sys_refcursor;
    r t27374%rowtype;
begin
    open rc for select * from t27374 order by code;
    fetch rc into r;
    dbms_output.put_line(r.code || ' ' || r.name || ' ' || r.gender);
    close rc;
end;
call p27374_rec_match();

evaluate 'M2: the same record against a two column select list is (2) against three fields';
create or replace procedure p27374_rec_short as
    rc sys_refcursor;
    r t27374%rowtype;
begin
    open rc for select code, name from t27374;
    fetch rc into r;
    close rc;
end;
call p27374_rec_short();

-- ----------------------------------------------------------------------------
-- B group: one FETCH statement, two select lists. This is why the check cannot
-- be a compile-time one for a SYS_REFCURSOR: the statement the cursor holds is
-- decided by the control flow.
-- ----------------------------------------------------------------------------

create or replace procedure p27374_branch(p_both int) as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    if p_both = 1 then
        open rc for select code, name from t27374 order by code;
    else
        open rc for select code from t27374 order by code;
    end if;
    fetch rc into vcode, vname;
    dbms_output.put_line(vcode || ' ' || vname);
    close rc;
end;

evaluate 'B1: the branch opening the two column select list matches the two INTO variables';
call p27374_branch(1);

evaluate 'B2: the other branch of the same procedure opens (1), so the same FETCH is a mismatch';
call p27374_branch(0);

-- ----------------------------------------------------------------------------
-- L1: the check runs at every FETCH, so a loop that fetches every row must not
-- be disturbed by it
-- ----------------------------------------------------------------------------

evaluate 'L1: a loop that fetches every row is not disturbed by the check';
create or replace procedure p27374_loop as
    rc sys_refcursor;
    vcode int;
    vname varchar(40);
begin
    open rc for select code, name from t27374 order by code;
    loop
        fetch rc into vcode, vname;
        exit when rc%notfound;
        dbms_output.put_line(vcode || ' ' || vname);
    end loop;
    close rc;
end;
call p27374_loop();

-- ----------------------------------------------------------------------------
-- clean up the shared database. p27374_c_short normally fails to compile, so its
-- drop reports "does not exist"; it is dropped anyway so that a spec change or a
-- bug letting it compile does not leave it behind.
-- ----------------------------------------------------------------------------

drop procedure p27374_d_short;
drop procedure p27374_d_long;
drop procedure p27374_d_match;
drop procedure p27374_d_star;
drop procedure p27374_d_using;
drop procedure p27374_s_short;
drop procedure p27374_s_match;
drop procedure p27374_c_short;
drop procedure p27374_c_match;
drop procedure p27374_reopen;
drop procedure p27374_closed;
drop procedure p27374_null;
drop procedure p27374_rec_match;
drop procedure p27374_rec_short;
drop procedure p27374_branch;
drop procedure p27374_loop;
drop table if exists t27374;

--+ server-message off
