-- [er]create table with bit data type and insert numberic data


CREATE CLASS t1(
   col1       bit(20)
);

INSERT INTO t1 VALUES (1111111111);

drop t1;