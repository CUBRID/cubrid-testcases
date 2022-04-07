--+ holdcas on;
-- [er]create class with  collection type and insert data using other user

call login ('dba','') on CLASS db_user;
create USER user1;

create class ddl_0001(
	st set(int) ,
	qt SEQUENCE(char(10)),
	mt MULTISET
);

call login ('user1','') on CLASS db_user;
insert into dba.ddl_0001 values({1,2,3},{'aaa','bbb'},null);


call login ('dba','') on CLASS db_user;

drop CLASS ddl_0001;

DROP USER user1;

--+ holdcas off;
