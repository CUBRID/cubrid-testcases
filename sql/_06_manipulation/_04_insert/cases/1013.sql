--test insert with two tables and a foreign key
create class tb1(
col1 int primary key,
col2 varchar
);

create class tb2(
col2_1 int,
col2_2 varchar,
foreign key (col2_1) references tb1(col1)
);

insert into tb1 values(1, 'bbb1');
insert into tb1 values(2, 'bbb2');
insert into tb1 values(3, 'bbb3');

insert into tb2 values(1, 'bbb11');
insert into tb2 values(2, 'bbb22');
insert into tb2 values(3, 'bbb33');

drop class tb2;
drop class tb1;