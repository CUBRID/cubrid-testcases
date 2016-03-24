-- create table with timestamp data type and insert TIMESTAMP data


CREATE CLASS t1(
   col1       timestamp
);

INSERT INTO t1 VALUES (TIMESTAMP '01/31/1994 8:15:00 pm');
INSERT INTO t1 VALUES (TIMESTAMP '8:15:00 pm 01/31/1994');

drop t1;