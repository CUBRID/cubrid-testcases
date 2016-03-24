-- [er] create classes,alter classes by adding attributes,alter class by adding super class,alter class by renaming an attribute of no existing class,drop class
CREATE CLASS ddl_0001;
CREATE CLASS ddl_0002;
ALTER ddl_0001 add col1 integer;
ALTER ddl_0001 add col2 varchar(100);
ALTER ddl_0002 add col1 integer;
ALTER ddl_0002 add col2 varchar(100);

ALTER ddl_0001 add superclass ddl_0002;

ALTER CLASS ddl_0003 rename attribute col1 as col11 ;
ALTER CLASS ddl_0003 rename attribute col2 as col22 ;




drop class ddl_0002;
drop class ddl_0001;