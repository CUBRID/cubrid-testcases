-- [er]create table with smallint data type and insert bit data


CREATE CLASS t1(
   col1       smallint 
);

INSERT INTO t1 VALUES (B'0001');

drop t1;