--create class,alter class by adding attributes,rename class name,rename attribute's name,drop class

CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 integer;
ALTER ddl_0001 add col2 varchar(10);
ALTER CLASS ddl_0001 rename col2 as col22;
RENAME CLASS ddl_0001 as ddl_0002;
ALTER ddl_0002 add col2 varchar(100);
ALTER CLASS ddl_0002 rename attribute col1 as col11;




drop class ddl_0002;