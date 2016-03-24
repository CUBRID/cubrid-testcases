--[er]Test function nullif with different data type

Create class t1(a date, b date, c timestamp);
insert into t1 values(DATE '05/09/2008', null, TIMESTAMP '05/09/2008 21:18:00');
insert into t1 values(DATE '05/10/2008', DATE '05/09/2008', TIMESTAMP '05/09/2008 9:00:00');
insert into t1 values(DATE '05/09/2008', DATE '05/09/2008', TIMESTAMP '05/09/2008 11:00:01');
insert into t1 values(NULL, DATE '05/09/2008', NULL);
insert into t1 values(DATE '05/10/2008', DATE '05/09/2008', NULL);


select coalesce(b,c)) from t1;
select coalesce(a,c)) from t1;
select coalesce(a,b)) from t1 where a is null;
                      

drop table t1;
