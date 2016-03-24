-- create table with timestamptz data type and insert timestamptz data


CREATE CLASS t1(
   col1       timestamptz
);

INSERT INTO t1 VALUES (timestamptz '01/31/1994 8:15:00 pm');
INSERT INTO t1 VALUES (timestamptz '8:15:00 pm 01/31/1994');

drop t1;