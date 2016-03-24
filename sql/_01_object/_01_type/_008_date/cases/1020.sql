-- create table with DATE data type and insert TIMESTAMP data


CREATE CLASS t1(
   col1       DATE
);

INSERT INTO t1 VALUES (TIMESTAMP '01/31/1994 8:15:00 pm');

drop t1;