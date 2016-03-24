--test operators seteq, subset, superset, superseteq,subseteq, superseteq, setneq with set(varchar) and set(int)
create class tb1 ( a set(varchar));
create class tb2 ( b set(integer));

insert into tb1 values({'a'});
insert into tb1 values({'b'});

insert into tb2 values({1});
insert into tb2 values({2});

select a,b from tb1, tb2 where a seteq b order by 1,2;
select a,b from tb1, tb2 where a setneq b order by 1,2;
select a,b from tb1, tb2 where a superset b order by 1,2;
select a,b from tb1, tb2 where a subset b order by 1,2;
select a,b from tb1, tb2 where a subseteq b order by 1,2;
select a,b from tb1, tb2 where a superseteq b order by 1,2;


drop class tb1;
drop class tb2;
