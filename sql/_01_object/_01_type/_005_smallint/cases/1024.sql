-- [er]create table with smallint data type and insert string data


CREATE CLASS t1(
   col1       smallint 
);

INSERT INTO t1 VALUES ('a');

drop t1;