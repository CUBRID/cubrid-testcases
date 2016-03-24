--create table with timestampltz data type and tests a create syntax with timestampltz data type and another constraint like unique,not null, shared 

CREATE CLASS ddl_0001(
   col1       timestampltz,
   col2       timestampltz NOT NULL,
   col3       timestampltz UNIQUE,
   col4       timestampltz UNIQUE NOT NULL,
   col5       timestampltz SHARED NULL,
   col6       timestampltz SHARED '1983-07-23 00:00' NOT NULL
);




drop ddl_0001;
