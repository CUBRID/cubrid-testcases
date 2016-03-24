--Test function COALESCE and nullif with char column

Create class t1(a char(5), b varchar(10), c char(5));
insert into t1 values('nhn1', 'nhnchina', null);
insert into t1 values(null, 'nhn2', 'nhn3');
insert into t1 values('nhn3', 'abcde', 'abcde');
insert into t1 values(null, null, null);
insert into t1 values('abcde', 'abcde', 'abcde');

select COALESCE(a, COALESCE(b,c)) from t1 order by 1;
select COALESCE(b, COALESCE(a,c)) from t1 order by 1;
select COALESCE(c, COALESCE(a,b)) from t1 where a is null order by 1;
                      

drop table t1;
