--Test in with multiset

create class t1 (c1 int, c2 multiset varchar(20));
insert into t1 values(101, {'a','b','c','a','b'});
insert into t1 values(102, {'l','m','n','l','m'});
insert into t1 values(103, {'x','y','z','z','y'});
insert into t1 values(104, {'d','e','f'});

select * from t1 where 'a' in c2;
select * from t1 where 'b' in c2;
select * from t1 where 'd' in c2;
select * from t1 where 'l' in c2;
select * from t1 where 'a' in c2;
select * from t1 where c2 in ({'a','b','c'});


drop class t1;
