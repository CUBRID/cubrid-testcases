-- [er]create table with NUMERIC data type and insert string data


CREATE CLASS t1(
   col1     NUMERIC
);

INSERT INTO t1 VALUES ('a');

drop t1;