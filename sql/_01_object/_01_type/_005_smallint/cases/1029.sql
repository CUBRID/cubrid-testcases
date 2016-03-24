-- [er]create table with smallint data type and insert Collections data


CREATE CLASS t1(
   col1       smallint 
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;