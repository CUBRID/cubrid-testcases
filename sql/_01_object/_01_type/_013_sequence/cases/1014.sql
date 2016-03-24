-- [er]create table with SEQUENCE data type and insert string data


CREATE CLASS t1(
   col1       SEQUENCE
);

INSERT INTO t1 VALUES ('a');

drop t1;