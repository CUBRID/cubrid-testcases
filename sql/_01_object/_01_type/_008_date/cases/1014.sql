-- [er]create table with DATE data type and insert string data


CREATE CLASS t1(
   col1       DATE
);

INSERT INTO t1 VALUES ('a');

drop t1;