-- [er]create table with smallint data type of length and insert numberic data


CREATE CLASS t1(
   col1       smallint(10) 
);

INSERT INTO t1 VALUES (-1 );

drop t1;