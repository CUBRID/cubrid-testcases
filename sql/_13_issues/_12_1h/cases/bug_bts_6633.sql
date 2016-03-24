--TEST: [Pseudocolumn in DEFAULT clause] USER default value will change from upper case to lower case when using 'insert ... select ...' syntax to insert a default value.


--+ holdcas on;

create table foo (a int, b string default user);
create table boo (a int, b string default user);

-- insertion will be handled by broker
insert into foo (a) values (1);
-- insertion will be handled by server
insert into boo (a) select (a) from foo;

-- verify that the inserted default user values are the same (uppercase)
select if (foo.a = boo.a, 'ok', 'not ok') from foo, boo;

drop foo;
drop boo;

-- call login test
call login ('dba', '') on class db_user;
create user testuser password 'testpw';
call login ('testuser','testpw') on class db_user;

create table foo (a int, b string default user);
create table boo (a int);

insert into boo values (2);

insert into foo (a) values (1);
insert into foo (a) select * from boo;

select * from foo order by a,b;

drop boo;
drop foo;

call login ('dba','') on class db_user;
drop user testuser;

create user a2345678901234567890123456789012;
drop user a2345678901234567890123456789012;

create user a234567890123456789012345678901;
drop user a234567890123456789012345678901;

call add_user ('a2345678901234567890123456789012','') on class db_user;
call drop_user ('a2345678901234567890123456789012','') on class db_user;

call add_user ('a234567890123456789012345678901','') on class db_user;
call drop_user ('a234567890123456789012345678901','') on class db_user;


call add_user ('aaaaaaaBBBBBBBcccccccDDDDDDDeee', '') on class db_user;
call login('aaaaaaaBBBBBBBcccccccDDDDDDDeee', '') on class db_user;

create table foo(a int, b varchar default current_user);
insert into foo(a) values(1);
insert into foo(a) select a from foo;

select * from foo;

drop table foo;

call login ('dba','') on class db_user;
drop user AAAAAAABBBBBBBCCCCCCCDDDDDDDEEE;


--+ holdcas off;
