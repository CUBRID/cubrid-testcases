-- [er]create table with timestamptz data type and insert nchar data


CREATE CLASS t1(
   col1       timestamptz 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;