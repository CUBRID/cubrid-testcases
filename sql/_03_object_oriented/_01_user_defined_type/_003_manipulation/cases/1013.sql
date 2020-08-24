--test update using two class 
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


update tb2 set col1=4 where col1=1;
update tb1 set col1=4 where col1=1;
update tb1 set col1=4,col2=(select tb2 from tb2 where col1=2) where col1=1;

drop class tb1;
drop class tb2;

set system parameters 'create_table_reuseoid=yes';
