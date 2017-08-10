--+ holdcas on;

drop table if exists tbl03part;
drop table if exists tbl03part__p__after_100;
CREATE TABLE tbl03part( i integer, s VARCHAR(30) ) collate utf8_en_cs
PARTITION BY RANGE (i)
(PARTITION before_100 VALUES LESS THAN (100),
PARTITION after_100 VALUES LESS THAN MAXVALUE );

show full columns from tbl03part;
show full columns from tbl03part__p__before_100;
show full columns from tbl03part__p__after_100;

alter table tbl03part collate utf8_en_ci;

alter table tbl03part PROMOTE PARTITION after_100;
alter table tbl03part__p__after_100 add column s2 string;

show full columns from tbl03part;
show full columns from tbl03part__p__before_100;
show full columns from tbl03part__p__after_100;

drop tbl03part;
drop tbl03part__p__after_100;

commit;
--+ holdcas off;
