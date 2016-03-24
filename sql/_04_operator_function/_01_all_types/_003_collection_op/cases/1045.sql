--test operators seteq, subset, superset, superseteq,subseteq, superseteq, setneq with set(bit) and set(bit varying)
create class tb1 ( a set(bit(8)));
create class tb2 ( b set(bit VARYING(8)));

insert into tb1 values({b'0001'});
insert into tb1 values({b'0010'});
insert into tb1 values({b'0100'});

insert into tb2 values({b'0001'});
insert into tb2 values({b'0010'});
insert into tb2 values({b'0100'});
insert into tb2 values({b'0000'});
insert into tb2 values({b'0001'});

select a,b from tb1, tb2 where a seteq b order by 1,2;
select a,b from tb1, tb2 where a superset b order by 1,2;
select a,b from tb1, tb2 where a subset b order by 1,2;
select a,b from tb1, tb2 where a setneq b order by 1,2;
select a,b from tb1, tb2 where a subseteq b order by 1,2;
select a,b from tb1, tb2 where a superseteq b order by 1,2;

drop class tb1;
drop class tb2;
