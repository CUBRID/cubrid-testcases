--[er]Test rownum in correlated subquery
create class t1(col1 integer, col2 varchar(20));
create class t2(col1 integer, col2 varchar(20));
insert into t1 values(101, 'aaa');
insert into t1 values(102, 'bbb');
insert into t1 values(103, 'ccc');
insert into t1 values(104, 'ddd');

insert into t2 values(201, 'aaa');
insert into t2 values(202, 'bbb');
insert into t2 values(203, 'ccc');
insert into t2 values(204, 'ddd');


select * from t1
  where rownum < ( select count(*) 
                   from t2
                   where t2.col2 = t1.col2);

drop class t1;
drop class t2;
