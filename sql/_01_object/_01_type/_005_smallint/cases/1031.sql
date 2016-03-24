-- [er]create table with smallint data type and insert nchar data


CREATE CLASS t1(
   col1       smallint 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1; 