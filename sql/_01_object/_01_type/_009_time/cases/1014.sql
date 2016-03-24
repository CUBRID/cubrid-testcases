-- [er]create table with TIME data type and insert string data


CREATE CLASS t1(
   col1       TIME
);

INSERT INTO t1 VALUES ('a');

drop t1;