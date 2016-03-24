--create table with timestamp data type and tests a create syntax with timestamp data type and another constraint like unique,not null, shared 

CREATE CLASS ddl_0001(
   col1       timestamp,
   col2       timestamp NOT NULL,
   col3       timestamp UNIQUE,
   col4       timestamp UNIQUE NOT NULL,
   col5       timestamp SHARED NULL,
   col6       timestamp SHARED '1983-07-23 00:00' NOT NULL
);




drop ddl_0001;
