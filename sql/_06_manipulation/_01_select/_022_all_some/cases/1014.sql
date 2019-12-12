--test all with collection 

create class t1 (c1 set int, c2 varchar(20));

insert into t1 values({101,102}, 'aaa');
insert into t1 values({102,103}, 'bbb');
insert into t1 values({103,104}, 'ddd');
insert into t1 values({104,105}, 'ccc');
insert into t1 values({105,106}, 'eee');
insert into t1 values({107,108}, 'eee');

select * from t1 where c1 < all(select c1 from t1 where c2='eee') order by 1;
select * from t1 where c1 = all(select c1 from t1 where c2='eee') order by 1;
select * from t1 where c1 > all(select c1 from t1 where c2='eee') order by 1;
select * from t1 where c1 <> all(select c1 from t1 where c2='eee') order by 1;
drop class t1;
