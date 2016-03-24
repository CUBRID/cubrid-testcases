--[er]test in with set and column
create class t1 (c1 int, c2 set varchar(20));
insert into t1 values(101, {'a','b','c'});
insert into t1 values(102, {'l','m','n'});
insert into t1 values(103, {'x','y','z'});
insert into t1 values(104, {'d','e','f'});

select * from t1 where 'a' in c2;
select * from t1 where 'b' in c2;
select * from t1 where 'd' in c2;
select * from t1 where 'l' in c2;
select * from t1 where 'a' in c2;
select * from t1 where {'a', 'b'} in c2;


drop class t1;
