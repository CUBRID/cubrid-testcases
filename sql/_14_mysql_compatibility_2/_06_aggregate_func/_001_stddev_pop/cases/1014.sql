--test STDDEV_POP function with all, distinct, unique

create class tb(
col1 int
);

insert into tb values(10);
insert into tb values(20);
insert into tb values(30);

select STDDEV_POP(all distinct unique col1) from tb;
select STDDEV_POP(all distinct col1) from tb;
select STDDEV_POP(distinct unique col1) from tb;
select STDDEV_POP(unique all col1) from tb;

drop class tb;
