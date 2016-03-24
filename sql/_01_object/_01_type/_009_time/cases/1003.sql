-- [er]create table with time data type and insert error time

CREATE CLASS ddl_0001(
   col1       time
);


insert INTO ddl_0001 VALUES (TIME '1:70:45 pm');

drop ddl_0001;