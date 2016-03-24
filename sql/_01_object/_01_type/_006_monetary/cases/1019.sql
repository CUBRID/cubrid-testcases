-- [er]create table with monetary data type and insert time data


CREATE CLASS t1(
   col1       monetary
);

INSERT INTO t1 VALUES (TIME '1:15:45 pm');

drop t1;