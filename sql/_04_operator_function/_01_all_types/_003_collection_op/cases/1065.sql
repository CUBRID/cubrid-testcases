--[er]test operators superseteq with list(float) and list(double)
create class tb1 ( a list(float));
create class tb2 ( b list(double));

insert into tb1 values({1.1});
insert into tb1 values({2.22});
insert into tb1 values({3.333});
insert into tb1 values({4});

insert into tb2 values({1.1});
insert into tb2 values({2.22});
insert into tb2 values({3.333});
insert into tb2 values({4});
insert into tb2 values({5});

select a,b from tb1, tb2 where a superseteq b order by 1,2;


drop class tb1;
drop class tb2;
