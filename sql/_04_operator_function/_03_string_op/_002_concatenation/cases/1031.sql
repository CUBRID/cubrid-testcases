--test operator + with time and int
create class tb(
		col1 time,
		col2 int
);

insert into tb  values('8:8:8 am', 10);

select col1+col2 from tb;


drop class tb;

