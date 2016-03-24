-- [er]create table with DOUBLE data type of length and insert  data


CREATE CLASS t1(
   col1     DOUBLE(10)
);

INSERT INTO t1 VALUES (11);

drop t1;