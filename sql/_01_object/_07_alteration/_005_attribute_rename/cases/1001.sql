--create class,alter class by renaming attribute

CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 integer;
ALTER ddl_0001 add col2 varchar(100);
ALTER CLASS ddl_0001 rename attribute col1 as col11 ;
ALTER CLASS ddl_0001 rename attribute col2 as col22 ;




drop class ddl_0001;