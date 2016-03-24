-- [er]create table with nchar VARYING data type and insert bit data


CREATE CLASS t1(
   col1       nchar VARYING(20)
);

INSERT INTO t1 VALUES (B'0001');

drop t1;