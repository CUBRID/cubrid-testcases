--[er]test operators subseteq with list type
create class tb1 ( a list);
create class tb2 ( b list);

insert into tb1 values({1,'a'});
insert into tb1 values({2,'b'});

insert into tb2 values({1,'a'});
insert into tb2 values({2,'b'});
insert into tb2 values({3,'c'});

select a,b from tb1, tb2 where a subseteq b order by 1,2;

drop class tb1;
drop class tb2;
