--create table with time data type and tests a create syntax with time data type and another constraint like unique,not null, shared 

CREATE CLASS ddl_0001(
   col1       time,
   col2       time NOT NULL,
   col3       time UNIQUE,
   col4       time UNIQUE NOT NULL,
   col5       time SHARED NULL,
   col6       time SHARED '00:01' NOT NULL
);




drop ddl_0001;
