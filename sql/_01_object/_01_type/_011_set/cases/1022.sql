-- [er]create table with SET data type and insert nchar data


CREATE CLASS t1(
   col1       SET 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;