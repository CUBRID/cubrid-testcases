drop table if exists t;
drop table if exists t__p__before_2001;
drop table if exists t__p__before_2016;
drop table if exists t__p__last_one;
CREATE TABLE t (years INT,nation CHAR(3),gold INT,silver INT,bronze INT)
PARTITION BY RANGE (years) (
    PARTITION before_2001 VALUES LESS THAN (2001),
    PARTITION before_2016 VALUES LESS THAN (2016)
);
insert into t select 1988,'n'||rownum,rownum+1,rownum+2,rownum+3 from db_root connect by level<=99;
create  unique index idx_all on t(years,nation,gold);
update statistics on t;
alter table t add partition (PARTITION last_one VALUES LESS THAN MAXVALUE);
insert into t select 2020,'n'||rownum,rownum+1,rownum+2,rownum+3 from db_root connect by level<=99;
select /*+ recompile*/ count(* ) from t__p__last_one where years>0;

update statistics on all classes with fullscan;
show index from t__p__last_one;
ALTER TABLE t  PROMOTE PARTITION last_one;
select  /*+ recompile */ count(* ) from t__p__last_one where years>0;
show index from t__p__last_one;


drop table if exists t;
drop table if exists t__p__before_2001;
drop table if exists t__p__before_2016;
drop table if exists t__p__last_one;


drop table if exists t;
CREATE TABLE t (years INT,nation CHAR(3),gold INT,silver INT,bronze INT)
PARTITION BY RANGE (nation) (
    PARTITION before_2001 VALUES LESS THAN ('n114'),
    PARTITION before_2016 VALUES LESS THAN ('n227')
);
create  unique index idx_all on t(years,nation,gold,silver,bronze);
alter table t add partition (PARTITION last_one VALUES LESS THAN MAXVALUE);
select /*+ recompile*/ count(* ) from t__p__last_one where years>0;
show index from t__p__last_one;
drop  t__p__last_one;
ALTER TABLE t  PROMOTE PARTITION last_one;
select /*+ recompile */ count(* ) from t__p__last_one where years>0;
show index from t__p__last_one;
drop table if exists t;
drop table if exists t__p__before_2001;
drop table if exists t__p__before_2016;
drop table if exists t__p__last_one;
