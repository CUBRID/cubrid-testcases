--test var_samp function with all, distinct, unique

create class tb(
col1 int
);

insert into tb values(10);
insert into tb values(20);
insert into tb values(30);

select var_samp(all distinct unique col1) from tb;
select var_samp(all distinct col1) from tb;
select var_samp(distinct unique col1) from tb;
select var_samp(unique all col1) from tb;

drop class tb;
