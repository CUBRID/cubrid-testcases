-- [er]create table with  BIT VARYING data type and insert time data


CREATE CLASS t1(
   col1       BIT VARYING(20)
);

INSERT INTO t1 VALUES (TIME '1:15:45 pm');

drop t1;