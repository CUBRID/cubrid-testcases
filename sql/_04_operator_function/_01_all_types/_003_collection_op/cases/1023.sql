--test operators seteq, subset, superset, superseteq with set(char) and set(varchar)
create class tb1 ( a set(char(2)));
create class tb2 ( b set(varchar(2)));

insert into tb1 values({'a1'});
insert into tb1 values({'a2'});
insert into tb1 values({'a3'});

insert into tb2 values({'a1'});
insert into tb2 values({'a2'});
insert into tb2 values({'a3'});
insert into tb2 values({'a4'});
insert into tb2 values({'a5'});

select a,b from tb1, tb2 where a seteq b order by 1,2;
select a,b from tb1, tb2 where a superset b order by 1,2;
select a,b from tb1, tb2 where a subset b order by 1,2;
select a,b from tb1, tb2 where a setneq b order by 1,2;
select a,b from tb1, tb2 where a subseteq b order by 1,2;
select a,b from tb1, tb2 where a superseteq b order by 1,2;

drop class tb1;
drop class tb2;
