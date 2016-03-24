-- [er]create table with TIME data type and insert date data


CREATE CLASS t1(
   col1       TIME
);

INSERT INTO t1 VALUES (DATE '11/11/1994');

drop t1;