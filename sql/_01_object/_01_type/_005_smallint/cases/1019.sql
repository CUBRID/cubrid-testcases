-- [er]create table with smallint data type and insert numberic data unaccepted


CREATE CLASS t1(
   col1       smallint 
);

INSERT INTO t1 VALUES (-32768 );

drop t1;