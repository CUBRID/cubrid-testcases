-- create table with smallint data type and insert numberic data


CREATE CLASS t1(
   col1       smallint 
);

INSERT INTO t1 VALUES (32767 );

drop t1;