-- [er]create table with timestampltz data type and insert nchar data


CREATE CLASS t1(
   col1       timestampltz 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;