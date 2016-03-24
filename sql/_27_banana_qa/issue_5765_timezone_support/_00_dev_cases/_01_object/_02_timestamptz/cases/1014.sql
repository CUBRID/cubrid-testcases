-- [er]create table with timestamptz data type and insert string data


CREATE CLASS t1(
   col1       timestamptz
);

INSERT INTO t1 VALUES ('a');

drop t1;