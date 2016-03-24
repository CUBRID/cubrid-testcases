--[er]test operators subseteq with list(integer) and list(smallint)
create class tb1 ( a list(integer));
create class tb2 ( b list(smallint));

insert into tb1 values({1});
insert into tb1 values({2});
insert into tb1 values({3});

insert into tb2 values({1});
insert into tb2 values({2});
insert into tb2 values({3});
insert into tb2 values({4});
insert into tb2 values({5});

select a,b from tb1, tb2 where a subseteq b order by 1,2;

drop class tb1;
drop class tb2;
