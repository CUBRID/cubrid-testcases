-- [er]create table with timestampltz data type and insert string data


CREATE CLASS t1(
   col1       timestampltz
);

INSERT INTO t1 VALUES ('a');

drop t1;