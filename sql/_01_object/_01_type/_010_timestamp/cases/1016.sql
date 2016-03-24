-- create table with timestamp data type and insert numberic data


CREATE CLASS t1(
   col1       timestamp
);

INSERT INTO t1 VALUES (1111111111);

drop t1;