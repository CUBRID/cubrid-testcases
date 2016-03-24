--Instead of rownum with inst_num() 
create class t1(col1 integer, col2 varchar(20));

insert into t1 values(101, 'aaa');
insert into t1 values(102, 'bbb');
insert into t1 values(103, 'ccc');
insert into t1 values(104, 'ddd');



select count(*)  from (select * from t1 where inst_num() < 2) x;

drop class t1;
