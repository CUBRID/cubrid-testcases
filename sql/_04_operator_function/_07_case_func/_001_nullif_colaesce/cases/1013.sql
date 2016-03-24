--Test function nullif,coalesce with different data type

Create class t1(a int, b date, c timestamp);
insert into t1 values(5, null, TIMESTAMP '05/09/2008 21:18:00');
insert into t1 values(5, DATE '05/09/2008', TIMESTAMP '05/09/2008 9:00:00');
insert into t1 values(6, DATE '05/09/2008', TIMESTAMP '05/09/2008 11:00:01');
insert into t1 values(NULL, DATE '05/09/2008', NULL);
insert into t1 values(6, DATE '05/09/2008', NULL);

select nullif(a,extract(month from c)) from t1 order by 1;
select coalesce(a,extract(month from c)) from t1 order by 1;
                      
drop table t1;
