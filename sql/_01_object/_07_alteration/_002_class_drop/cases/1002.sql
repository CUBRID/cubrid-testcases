--create class and alter class by adding some attributes,drop the specified attributes of classes
CREATE CLASS ddl_0001;

ALTER CLASS ddl_0001 ADD ATTRIBUTE col1  integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col2  varchar(100) nOt nUlL unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col3  varchar(100) unique NOT NULL;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col4  varchar(100) default 'hello' NoT NuLl;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col5  varchar(100) default 'hello' not null;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col6  numeric(10,5);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col7  numeric(10,5);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col8  numeric(10,5);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col9  integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col10 integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col11 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col12 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col13 numeric(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col14 numeric(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col15 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col16 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col17 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col18 timestamp;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col19 timestamp;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col20 timestamp;

ALTER CLASS ddl_0001 drop attribute col20;
ALTER CLASS ddl_0001 drop attribute col17;
ALTER CLASS ddl_0001 drop col13;
ALTER CLASS ddl_0001 drop col11;
ALTER ddl_0001 drop col8;
ALTER ddl_0001 drop col1;




drop class ddl_0001;