--create a class,add a varchar data type field,change the field's default value to be int data type value

CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 varchar(100);
ALTER ddl_0001 modify col1 int default 12345;




drop class ddl_0001;