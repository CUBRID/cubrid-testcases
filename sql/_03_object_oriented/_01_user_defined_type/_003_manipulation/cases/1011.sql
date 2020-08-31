--test delete using two class 
set system parameters 'create_table_reuseoid=no';

create class tb2(
		col1 int
);

create class tb1(
	col1 int,
	col2 tb2
);


insert into tb1 values(1, insert into tb2 values(1));
insert into tb1 values(2, insert into tb2 values(2));
insert into tb1 values(3, insert into tb2 values(3));


delete from tb2 where col1=1;
delete from tb1 where col2=(select tb2 from tb2 where col1=2);

drop class tb1;
drop class tb2;

set system parameters 'create_table_reuseoid=yes';
