-- [er]create table with SEQUENCE data type and insert numberic data


CREATE CLASS t1(
   col1       SEQUENCE
);

INSERT INTO t1 VALUES (1111111111);

drop t1;