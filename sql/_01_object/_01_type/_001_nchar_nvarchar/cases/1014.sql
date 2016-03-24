-- [er]create table with nchar VARYING data type and insert string data


CREATE CLASS t1(
   col1       nchar VARYING(20)
);

INSERT INTO t1 VALUES ('a');

drop t1;