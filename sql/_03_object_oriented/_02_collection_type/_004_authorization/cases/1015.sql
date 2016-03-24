--+ holdcas on;
--[er]test AUTHORIZATION(insert) using a class which has set type columns
call login ('dba','') on CLASS db_user;
create USER user1;

create class ddl_0001(
    id int auto_increment PRIMARY key,
	st set(int) ,
	qt SEQUENCE(char(10)),
	mt MULTISET

);

insert into ddl_0001 (st,qt,mt) values({1,2,3},{'aaa','bbb'},null);

grant select, delete, update on ddl_0001 to user1;

call login ('user1','') on CLASS db_user;

insert into ddl_0001 (st,qt,mt) values({4,5,6},{'aaa2','bbb2'},null);

delete from ddl_0001 where id=1;
update ddl_0001 set st={2,2,2} where id=2;
SELECT * FROM ddl_0001;

call login ('dba','') on CLASS db_user;
drop CLASS ddl_0001;

DROP USER user1;

--+ holdcas off;
