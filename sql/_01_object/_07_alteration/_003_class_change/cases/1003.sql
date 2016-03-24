--[er]create a class,add an int data type field,change the field's default value to be string data type value,then report error 
CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 int;
ALTER ddl_0001 modify col1 int default 'abcdefghijk';




drop class ddl_0001;