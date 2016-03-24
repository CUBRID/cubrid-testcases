--[er]test operators subset with list(varchar) and list(int)
create class tb1 ( a list(varchar));
create class tb2 ( b list(integer));

insert into tb1 values({'a'});
insert into tb1 values({'b'});

insert into tb2 values({1});
insert into tb2 values({2});

select a,b from tb1, tb2 where a subset b order by 1,2;

drop class tb1;
drop class tb2;
