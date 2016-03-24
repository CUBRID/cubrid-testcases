-- [er]create table with nchar VARYING data type and insert date data


CREATE CLASS t1(
   col1       nchar VARYING(20)
);

INSERT INTO t1 VALUES (DATE '11/11/1994');

drop t1;