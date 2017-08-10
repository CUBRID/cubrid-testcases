--test operator + with date and timestamp
create class tb(
		col1 timestamp,
		col2 int
);

insert into tb  values('8/8/2008 8:8:8 am', 10);

select col1+col2 from tb;


drop class tb;

