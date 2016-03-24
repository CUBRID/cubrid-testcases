--+ holdcas on;
-- test AUTHORIZATION(select,insert) using a class which has set type columns
call login ('dba','') on CLASS db_user;
create USER user1;


create class ddl_0001(
	st set(int) ,
	qt SEQUENCE(char(10)),
	mt MULTISET

);
insert into ddl_0001 values({1,2,3},{'aaa','bbb'},null);


grant SELECT,INSERT on ddl_0001 to user1;

call login ('user1','') on CLASS db_user;

insert into ddl_0001 values({4,5,6},{'aaa2','bbb2'},null);
SELECT * FROM ddl_0001 order by 1;

call login ('dba','') on CLASS db_user;
drop CLASS ddl_0001;

DROP USER user1;

--+ holdcas off;
