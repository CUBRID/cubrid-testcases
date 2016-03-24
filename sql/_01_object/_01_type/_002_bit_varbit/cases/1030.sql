-- create table with BIT VARYING data type and insert bit data


CREATE CLASS t1(
   col1       BIT VARYING(20)
);

INSERT INTO t1 VALUES (B'0001');

drop t1;