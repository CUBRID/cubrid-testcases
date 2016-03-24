--add various data type's attribute and method with several constraints 
 

CREATE CLASS ddl_0001;

ALTER CLASS ddl_0001 ADD ATTRIBUTE col1  integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col2  varchar(100) default 'hello' nOt nUlL;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col3  varchar(100) default 'hello' NOT NULL;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col4  varchar(100) NoT NuLl unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col5  varchar(100) not null unique;
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

-- ADD FILE
ALTER CLASS ddl_0001 ADD FILE '$HOME/method_test/myyang';
-- ADD FILE 
ALTER CLASS ddl_0001 ADD FILE '$HOME/method_test/myyang1';

-- ADD METHOD
ALTER CLASS ddl_0001 ADD METHOD get_2000() int FUNCTION TEST_getInt;
-- ADD METHOD 
ALTER CLASS ddl_0001 ADD METHOD get_2002() int FUNCTION TEST_getInt2002;





drop class ddl_0001;
