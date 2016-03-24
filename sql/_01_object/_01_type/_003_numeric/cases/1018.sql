-- [er]create table with NUMERIC data type and insert date data


CREATE CLASS t1(
   col1       NUMERIC
);

INSERT INTO t1 VALUES (DATE '11/11/1994');

drop t1;