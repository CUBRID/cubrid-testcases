-- [er]create table with SET data type and insert bit data


CREATE CLASS t1(
   col1       SET
);

INSERT INTO t1 VALUES (B'0001');

drop t1;