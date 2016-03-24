--test operators seteq, subset, superset, superseteq,subseteq, superseteq, setneq with multiset(integer) and multiset(smallint)
create class tb1 ( a multiset(integer));
create class tb2 ( b multiset(smallint));

insert into tb1 values({1});
insert into tb1 values({2});
insert into tb1 values({3});

insert into tb2 values({1});
insert into tb2 values({2});
insert into tb2 values({3});
insert into tb2 values({4});
insert into tb2 values({5});

select a,b from tb1, tb2 where a seteq b order by 1,2;
select a,b from tb1, tb2 where a superset b order by 1,2;
select a,b from tb1, tb2 where a subset b order by 1,2;
select a,b from tb1, tb2 where a setneq b order by 1,2;
select a,b from tb1, tb2 where a subseteq b order by 1,2;
select a,b from tb1, tb2 where a superseteq b order by 1,2;


drop class tb1;
drop class tb2;
