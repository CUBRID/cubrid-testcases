-- [er]create table with monetary data type and insert string data


CREATE CLASS t1(
   col1     monetary
);

INSERT INTO t1 VALUES ('a');

drop t1;