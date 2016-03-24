-- [er]create table with timestamp data type and insert numberic data


CREATE CLASS t1(
   col1       timestamp
);

INSERT INTO t1 VALUES (-92748923.124123412341);

drop t1;