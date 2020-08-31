--test insert, select, update, delete with 3 depth
set system parameters 'create_table_reuseoid=no';

create class tb4(
	    col1 int
	);

	create class tb3(
	    col1 int,
	    col2 tb4
	);

	create class tb2(
		col1 int,
		col2 tb3
	);

	create class tb1(
		col1 int,
		col2 tb2
	);


	insert into tb1 values(1, insert into tb2 values(1, insert into tb3 values(1, insert into tb4 values(1))));
	insert into tb1 values(2, insert into tb2 values(2, insert into tb3 values(2, insert into tb4 values(2))));
	insert into tb1 values(3, insert into tb2 values(3, insert into tb3 values(3, insert into tb4 values(3))));

	select col2.col2.col2.col1 from tb1;

	update tb1 set col1=20 where col2.col2.col2.col1 =1;

	delete from tb1 where col2.col2.col2.col1 =2;

	drop class tb1;
	drop class tb2;
	drop class tb3;
	drop class tb4;

set system parameters 'create_table_reuseoid=yes';
