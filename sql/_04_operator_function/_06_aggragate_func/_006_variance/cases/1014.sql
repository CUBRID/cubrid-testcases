--test variance function with all, distinct, unique

create class tb(
col1 int
);

insert into tb values(10);
insert into tb values(20);
insert into tb values(30);

select variance(all distinct unique col1) from tb;
select variance(all distinct col1) from tb;
select variance(distinct unique col1) from tb;
select variance(unique all col1) from tb;

drop class tb;
