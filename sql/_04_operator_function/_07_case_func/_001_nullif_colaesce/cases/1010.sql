--Test function COALESCE and nullif with date datetype

Create class t1(a date, b date, c date);
insert into t1 values(DATE '05/09/2008', null, DATE '05/09/2008');
insert into t1 values(DATE '05/10/2008', DATE '05/09/2008', DATE '05/09/2008');
insert into t1 values(DATE '05/09/2008', DATE '05/09/2008', DATE '05/09/2008');
insert into t1 values(NULL, DATE '05/09/2008', NULL);
insert into t1 values(DATE '05/10/2008', DATE '05/09/2008', NULL);


select COALESCE(a, COALESCE(b,c)) from t1 order by 1;
select COALESCE(b, COALESCE(a,c)) from t1 order by 1;
select COALESCE(c, COALESCE(a,b)) from t1 where a is null order by 1;
                      

drop table t1;
