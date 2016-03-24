-- [er]create table with monetary data type of length and insert data


CREATE CLASS t1(
   col1     monetary(10)
);

INSERT INTO t1 VALUES (1111);

drop t1;