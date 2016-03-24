--create table with timestamptz data type and tests a create syntax with timestamptz data type and another constraint like unique,not null, shared 

CREATE CLASS ddl_0001(
   col1       timestamptz,
   col2       timestamptz NOT NULL,
   col3       timestamptz UNIQUE,
   col4       timestamptz UNIQUE NOT NULL,
   col5       timestamptz SHARED NULL,
   col6       timestamptz SHARED '1983-07-23 00:00' NOT NULL
);




drop ddl_0001;
