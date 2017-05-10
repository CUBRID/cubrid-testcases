--filter index
drop if exists t;
create table t(col1 int,col2 varchar(20),col3 timestamp);
insert into t values(1,'book1','2007-12-24');
insert into t values(2,'book2','2008-12-24');
insert into t values(3,'book3','2009-12-24');
insert into t values(4,'book4','2010-12-24');
insert into t values(2,'book2','2008-12-24');
create index idx1  on t(col3) where year(col3)>2008;
select * from t where year(col3)>2008 order by 1 limit 0,1;
select col3 from t where year(col3)>2008 using index idx1(+) keylimit 0,1;
select col3 from t where year(col3)>2008 using index idx1(+) keylimit 0+1,1;
select col3 from t where year(col3)>2008 using index idx1(+) keylimit 0+1,2-1;
select col3 from t where year(col3)>2008 using index idx1(+) keylimit 0*1,1*1;
select col3 from t where year(col3)>2008 using index idx1(+) keylimit 2*1,1*1;
select col3 from t where year(col3)>2008 using index idx1(+) keylimit 2/2-1,1*1+1;

select col3 from t where year(col3)>2008 using index idx1(+) limit 0,1;
select col3 from t where year(col3)>2008 using index idx1(+) limit 0+1,1;
select col3 from t where year(col3)>2008 using index idx1(+) limit 0+1,2-1;
select col3 from t where year(col3)>2008 using index idx1(+) limit 0*1,1*1;
select * from t where year(col3)>2008 using index idx1(+) limit 0,1;
select col3 from t where year(col3)>2008 using index idx1(+) limit 2*1,1*1;
drop if exists t;
