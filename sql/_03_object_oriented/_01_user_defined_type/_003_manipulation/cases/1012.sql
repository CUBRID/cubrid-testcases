--test insert using self reference
set system parameters 'create_table_reuseoid=no';

create class tb1(
	col1 int,
	col2 tb1
);


insert into tb1 values(1, null);
insert into tb1 values(2, select tb1 from tb1 where col1=1);
insert into tb1 values(3, select tb1 from tb1 where col1=2);

select * from tb1;

drop class tb1;

set system parameters 'create_table_reuseoid=yes';
