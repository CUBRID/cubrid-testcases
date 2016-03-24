-- [er]create table with DOUBLE data type and insert TIMESTAMP data


CREATE CLASS t1(
   col1       DOUBLE
);

INSERT INTO t1 VALUES (TIMESTAMP '01/31/1994 8:15:00 pm');

drop t1;