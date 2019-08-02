drop if exists t;

CREATE TABLE t (i int, s varchar(10));

INSERT INTO t VALUES (1,'a');

--test: System error occures for below:
select  max(col1 + col2) from (select i as col1 from t ),(select i as col2 from t) order by col1+col2 limit 10;

drop if exists t;
