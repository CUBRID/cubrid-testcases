--test var_pop function with all, distinct, unique

create class tb(
col1 int
);

insert into tb values(10);
insert into tb values(20);
insert into tb values(30);

select var_pop(all distinct unique col1) from tb;
select var_pop(all distinct col1) from tb;
select var_pop(distinct unique col1) from tb;
select var_pop(unique all col1) from tb;

drop class tb;
