--[er]test delete two tables with foreign key
create class tb1(
	col1 int primary key,
	col2 varchar
);

create class tb2(
	col2_1 int,
	col2_2 varchar,
	foreign key (col2_1) references tb1(col1)
);

insert into tb1 values(1, 'abc1');
insert into tb1 values(2, 'abc2');

insert into tb2 values(1, 'aaa1');
insert into tb2 values(2, 'aaa2');

delete from tb1 where col1=1;

drop class tb2;
drop class tb1;
