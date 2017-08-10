--+ holdcas on;
--Test db_class using create new user and retrieve class of new user

--Create new user
create user test_user;

--Login in new user
call login('test_user') on class db_user;
--Create new class in current user
create class test_class(col1 integer);
insert into test_class values(999);
insert into test_class values(888);

select * from db_class 
where  owner_name = current_user;


drop class test_class;
call login('dba') on class db_user;
drop user test_user;

--+ holdcas off;
