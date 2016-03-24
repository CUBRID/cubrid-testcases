--create a class,alter the class to add a attribute and the default value,alter this class to change the attribute's default value

CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 string default '***';
ALTER CLASS ddl_0001 modify col1 string default '*****';




drop class ddl_0001;