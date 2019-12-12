--+ holdcas on;
set names binary;

drop table if exists t;
create table t(i int) collate binary;
alter table t add column s string collate binary;
insert into t values(1,'a');
select collation(s),charset(s),coercibility(s) from t order by 1,2,3;
insert into t values(2,null);
select collation(s),charset(s),coercibility(s) from t order by 1,2,3;

delete from t where s is null;
select collation(s),charset(s),coercibility(s) from t order by 1,2,3;

alter table t partition by range(s) (partition p0 values less than ('f'),
partition p1 values less than('t'),partition p2 values less than maxvalue);
select collation(s),charset(s),coercibility(s) from t order by 1,2,3;
select collation(s),charset(s),coercibility(s) from t__p__p0 order by 1,2,3;
insert into t values(2,null),(3,'s');
select collation(s),charset(s),coercibility(s) from t order by 1,2,3;
select collation(s),charset(s),coercibility(s) from t__p__p0 order by 1,2,3;
select collation(s),charset(s),coercibility(s) from t__p__p1 order by 1,2,3;
truncate t;
select collation(s),charset(s),coercibility(s) from t__p__p0 order by 1,2,3;
insert into t values(2,null),(1,'A'),(3,null);
select collation(s),charset(s),coercibility(s) from t order by 1,2,3;
select collation(s),charset(s),coercibility(s) from t__p__p2 order by 1,2,3;

drop t;
set names iso88591;

commit;
--+ holdcas off;