--test operator + with varchar and time
create class tb(
		col1 varchar,
		col2 time
);

insert into tb  values('varchar', '5:5:5 am');

select col1+col2 from tb;

drop class tb;

