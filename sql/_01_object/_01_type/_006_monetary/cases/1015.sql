-- [er]create table with  monetary data type and insert bit data


CREATE CLASS t1(
   col1       monetary
);

INSERT INTO t1 VALUES (B'0001');

drop t1;