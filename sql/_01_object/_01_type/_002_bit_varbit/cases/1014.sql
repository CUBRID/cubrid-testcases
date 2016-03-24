-- [er]create table with bit data type and insert string data


CREATE CLASS t1(
   col1     bit(20)
);

INSERT INTO t1 VALUES ('a');

drop t1;