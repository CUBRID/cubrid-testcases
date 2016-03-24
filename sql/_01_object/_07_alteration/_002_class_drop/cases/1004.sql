--create class,alter class by adding attribute,alter class by droping constraint

CREATE CLASS ddl_0001;

ALTER CLASS ddl_0001 ADD ATTRIBUTE col1  varchar(100) unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col2  varchar(100) unique NOT NULL;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col3  varchar(100) NoT NuLl unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col4  varchar(100);

alter class ddl_0001 drop constraint "u_ddl_0001_col1" ;





drop class ddl_0001;