---empty table left join
drop if exists t1;
create table t1(i int);
insert t1 values(1),(2),(3),(4);

drop if exists s1;
create table s1 (j int);
select a.*,b.* from t1 a left join  s1 b on a.i=b.j order by i;
select a.*,count(b.j) from t1 a left join  s1 b on a.i=b.j group by a.i order by i;
drop t1;
drop s1;

