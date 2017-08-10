--test operator + with varchar and timestamp
create class tb(
		col1 varchar,
		col2 timestamp
);

insert into tb  values('varchar', '8/8/2008 5:5:5 am');

select col1+col2 from tb;

drop class tb;

