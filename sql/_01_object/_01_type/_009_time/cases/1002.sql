-- [er]create table with time data type and insert data

CREATE CLASS ddl_0001(
   col1       time
);


insert INTO ddl_0001 VALUES (TIME '1:15:45 pm');
INSERT into ddl_0001 VALUEs (TIME '16:08:33 am');
INSERT INTO ddl_0001 VALUES (TIME '1:15');

drop ddl_0001;