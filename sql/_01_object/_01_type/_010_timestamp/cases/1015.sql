-- [er]create table with timestamp data type and insert bit data


CREATE CLASS t1(
   col1       timestamp
);

INSERT INTO t1 VALUES (B'0001');

drop t1;