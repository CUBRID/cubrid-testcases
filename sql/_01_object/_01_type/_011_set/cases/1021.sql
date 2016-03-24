-- create table with SET data type and insert Collections data


CREATE CLASS t1(
   col1       SET
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;