-- [er]create table with DOUBLE data type of length and insert  data unacced


CREATE CLASS t1(
   col1     DOUBLE 
);

INSERT INTO t1 VALUES (+10e+308 + 1);

drop t1;