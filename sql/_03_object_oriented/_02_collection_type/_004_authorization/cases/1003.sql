--+ holdcas on;
-- [er]create class with  collection type and update data using other user

call login ('dba','') on CLASS db_user;
create USER user1;

create class ddl_0001(
	st set(int) ,
	qt SEQUENCE(char(10)),
	mt MULTISET

);
insert into ddl_0001 values({1,2,3},{'aaa','bbb'},null);
call login ('user1','') on CLASS db_user;

update ddl_0001 set st={10,20,30};

SELECT * from ddl_0001;
call login ('dba','') on CLASS db_user;
drop CLASS ddl_0001;

DROP USER user1;


--+ holdcas off;
