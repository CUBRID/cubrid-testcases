-- create table with DOUBLE data type and insert numberic data


CREATE CLASS t1(
   col1       DOUBLE
);

INSERT INTO t1 VALUES (-10e+308);

drop t1;