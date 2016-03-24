-- create table with timestampltz data type and insert timestampltz data


CREATE CLASS t1(
   col1       timestampltz
);

INSERT INTO t1 VALUES (timestampltz '01/31/1994 8:15:00 pm');
INSERT INTO t1 VALUES (timestampltz '8:15:00 pm 01/31/1994');

drop t1;