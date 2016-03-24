-- create table with timestampltz data type and insert date data


CREATE CLASS t1(
   col1       timestampltz
);

INSERT INTO t1 VALUES (DATE '11/11/1994');

drop t1;