-- [er]create table with timestampltz data type and insert bit data


CREATE CLASS t1(
   col1       timestampltz
);

INSERT INTO t1 VALUES (B'0001');

drop t1;