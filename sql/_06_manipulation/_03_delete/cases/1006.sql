set system parameters 'create_table_reuseoid=no';
--[er]test delete two tables 
create class tb2(
	col1 int,
	col2 varchar
);

create class tb1(
	col1 int primary key,
	col2 varchar,
	col3 tb2
);

insert into tb1 values(1, 'bbb11', insert into tb2 values(1, 'bbb1'));
insert into tb1 values(2, 'bbb22', insert into tb2 values(1, 'bbb2'));
insert into tb1 values(3, 'bbb33', insert into tb2 values(1, 'bbb3'));

delete from tb1,tb2 where tb1.col1 = tb2.col1;

drop class tb2;
drop class tb1;
set system parameters 'create_table_reuseoid=yes';
