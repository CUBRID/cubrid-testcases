--test in with collection: set


create class t1 (c1 int, c2 set varchar(20));
insert into t1 values(101, {'a','b','c'});
insert into t1 values(102, {'l','m','n'});
insert into t1 values(103, {'x','y','z'});
insert into t1 values(104, {'d','e','f'});

select * from t1 where c2 in ({'a','b','c'}, {'l','m','n','j'});

drop class t1;
