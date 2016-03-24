-- create table with nchar VARYING data type and insert nchar data


CREATE CLASS t1(
   col1       nchar VARYING(20)
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;