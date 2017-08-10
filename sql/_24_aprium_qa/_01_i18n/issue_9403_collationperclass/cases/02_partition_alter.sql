--+ holdcas on;

drop table if exists tbl02part;
CREATE TABLE tbl02part( i integer, s VARCHAR(30) ) collate utf8_en_cs
PARTITION BY RANGE (i)
(PARTITION before_100 VALUES LESS THAN (100),
PARTITION after_100 VALUES LESS THAN MAXVALUE );

show full columns from tbl02part;
show full columns from tbl02part__p__before_100;
show full columns from tbl02part__p__after_100;

alter table tbl02part collate utf8_en_ci;

show full columns from tbl02part;
show full columns from tbl02part__p__before_100;
show full columns from tbl02part__p__after_100;

drop tbl02part;

commit;
--+ holdcas off;
