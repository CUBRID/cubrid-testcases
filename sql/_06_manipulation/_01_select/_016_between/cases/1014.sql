--Test predicate between with multiset
create class t1(id int, info set varchar(20));
insert into t1 values (101, {'Jerry', 'China','China'});
insert into t1 values (102, {'Tom', 'America','China'});
insert into t1 values (101, {'Nancy', 'Canada','China'});
insert into t1 values (101, {'Livina', 'Japan','China'});


select id, info from t1
where  info between {'Jerry', 'China', 'China'} and {'Livina', 'Japan', 'China'};


drop class t1;
