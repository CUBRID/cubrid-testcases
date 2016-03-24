-- [er]create table with SET data type and insert string data


CREATE CLASS t1(
   col1       SET
);

INSERT INTO t1 VALUES ('a');

drop t1;