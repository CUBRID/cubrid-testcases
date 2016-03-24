autocommit off;
call login('dba','') on class db_user;
create class boo(a int, b int) as select ssn, ssn from faculty2;
select * from boo;
update boo set a=3 where b=9;
select * from boo;
update boo set a=3, b=4 where b=3;
rollback;
