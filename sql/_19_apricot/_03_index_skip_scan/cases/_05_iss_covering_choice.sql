-- 1001 records: one above the tipping point
create table mille as select 0 from table({0,1,2,3,4,5,6,7,8,9}) t1, table({0,1,2,3,4,5,6,7,8,9}) t2, table({0,1,2,3,4,5,6,7,8,9}) t3;
insert into mille select 0 from db_root;
create table firstcol (i string, ord int);
insert into firstcol values ('aaaa', 4), ('bbbb', 2), ('cccc', 1), ('dddd', 5), ('eeee', 3);

create table t (i string not null, j int, k string);
insert into t (i,j,k) select f.i, rownum, cast ((rownum -1)/ (select count(*) from mille) as string) from firstcol f, mille order by f.ord;
create index idx on t(i,j,k);

update statistics on all classes;

-- index skip scan, because we are above the tipping point (ratio is 21)
select /*+ recompile  */ count(*) from (select /*+ recompile INDEX_SS */ k from t where j between 105 and 106 or j between 445 and 446 order by i) tbl;

-- make ratio 20, to drop below tipping point for ISS versus covering activation
delete from t where j % (select count(*) from mille) = 0;

commit;

update statistics on all classes;

commit;

-- this time, no iss, just covering (ratio fell to 1000)
select /*+ recompile */ count(*) from (select /*+ recompile index_ss */ k from t where j between 105 and 106 or j between 445 and 446 order by i) tbl;

drop table mille;
drop table firstcol;
drop table t;
