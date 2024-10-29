--+ server-message on
-- verified the CBRD-25570

create user u1;
create user u2;
create user u3 groups dba;

evaluate 'case 1: u1.test_sp() is search to dba table (error case)';
drop if exists a_view;
drop if exists a_tbl;

evaluate 'a_tbl, a_view owner is dba';
CREATE TABLE a_tbl (
    id INT NOT NULL
);
INSERT INTO a_tbl VALUES (1);

CREATE VIEW a_view AS SELECT * FROM a_tbl;

evaluate 'compile error: Syntax: Unknown class u1.a_view';
create or replace procedure u1.test_sp as
    cursor c is select a.id as id from a_view a;
begin
    FOR r IN c LOOP
        DBMS_OUTPUT.put_line(r.id);
    END LOOP;
end;

drop view a_view;
drop table a_tbl;



evaluate 'case 2: u1.test_sp() is search to u1 table but caller is u2 (succ case)';
drop if exists u1.a_view;
drop if exists u1.a_tbl;

evaluate 'a_tbl, a_view owner is u1';
CREATE TABLE u1.a_tbl (
    id INT NOT NULL,
    phone VARCHAR(10)
);
INSERT INTO u1.a_tbl VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);

CREATE VIEW u1.a_view AS SELECT * FROM u1.a_tbl WHERE phone IS NOT NULL WITH CHECK OPTION;

evaluate 'create a procedure of u1 in the dba user';
create or replace procedure u1.test_sp as
    cursor c is select a.id as id from u1.a_view a order by a.id;
begin
    FOR r IN c LOOP
        DBMS_OUTPUT.put_line(r.id);
    END LOOP;
end;

grant execute on procedure u1.test_sp to u2;

evaluate 'succ: call the procedure on u2';
call login('u2', '') on class db_user;

select u1.test_sp(), 'execute to the owner right (owner: u1)' from dual;

call login('dba', '') on class db_user;

drop procedure u1.test_sp;

drop view u1.a_view;
drop table u1.a_tbl;



evaluate 'case 3: dba group user has the same to dba permission';
create table t1 (id int, col1 char(1));
insert into t1 values(1,'c'),(2,'u'),(3,'b');

-- u3 is select to dba.t1
create or replace procedure u3.test_sp as
    cursor c is select col1 from dba.t1 a order by id;
begin
    DBMS_OUTPUT.put_line('u3 test_sp()');
    FOR r IN c LOOP
        DBMS_OUTPUT.put_line(r.col1);
    END LOOP;
end;

create or replace procedure u1.test_sp as
begin
    DBMS_OUTPUT.put_line('u1 test_sp()');
end;

evaluate 'grant to u2 from u3(=dba group)';
call login('u3', '') on class db_user;
grant execute on procedure u1.test_sp to u2;
grant execute on procedure u3.test_sp to u2;

evaluate 'connect to u2';
call login('u2', '') on class db_user;

call u1.test_sp();
call u3.test_sp();

evaluate 'connect to dba & test end';
call login('dba', '') on class db_user;

drop procedure u1.test_sp;
drop procedure u3.test_sp;
drop t1;


drop user u1;
drop user u2;
drop user u3;

--+ server-message off
