--[er]Test rownum with any attribute

create class t1(col1 integer, col2 varchar(20));

insert into t1 values(101, 'aaa');
insert into t1 values(102, 'bbb');
insert into t1 values(103, 'ccc');
insert into t1 values(104, 'ddd');



select * from t1 where rownum < col1;

drop class t1;
