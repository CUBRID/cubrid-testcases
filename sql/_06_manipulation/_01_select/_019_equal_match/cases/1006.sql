--test equal_match with null
create class t1 (c1 int, c2 varchar(20), c3 date);
insert into t1 values(101, 'aaaa', date'05/08/2008');
insert into t1 values(102, 'bbbb', date'06/08/2008');
insert into t1 values(103, 'cccc', date'07/08/2008');
insert into t1 values(104, 'dddd', date'08/08/2008');
insert into t1 values(105, 'eeee', date'09/08/2008');


select * from t1 where c1 = null;

select * from t1 where c1 <> null;

drop class t1;