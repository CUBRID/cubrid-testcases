-- [er]create table with nchar data type and insert numberic data


CREATE CLASS t1(
   col1       nchar  (20)
);

INSERT INTO t1 VALUES (-92748923.124123412341);

drop t1;