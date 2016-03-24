-- [er]create table with nchar data type and insert time data


CREATE CLASS t1(
   col1       nchar  (20)
);

INSERT INTO t1 VALUES (TIME '1:15:45 pm');

drop t1;