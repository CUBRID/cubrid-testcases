-- [er]create table with SEQUENCE data type and insert date data


CREATE CLASS t1(
   col1       SEQUENCE
);

INSERT INTO t1 VALUES (DATE '11/11/1994');

drop t1;