--+ holdcas on;

drop table if exists tbl01part;
CREATE TABLE tbl01part( i integer, s VARCHAR(30) ) collate utf8_en_cs
PARTITION BY RANGE (i)
(PARTITION before_100 VALUES LESS THAN (100),
PARTITION after_100 VALUES LESS THAN MAXVALUE );

show full columns from tbl01part;
show full columns from tbl01part__p__before_100;
show full columns from tbl01part__p__after_100;

drop tbl01part;

commit;
--+ holdcas off;
