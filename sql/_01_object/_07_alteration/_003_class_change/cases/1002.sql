--change a string data type field's default value 

CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 string;
ALTER ddl_0001 modify col1 string default 'abcdefghijklmnop';




drop class ddl_0001;