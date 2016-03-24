-- [er]create table with timestamp data type and insert string data


CREATE CLASS t1(
   col1       timestamp
);

INSERT INTO t1 VALUES ('a');

drop t1;