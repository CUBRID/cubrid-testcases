--test operator + with varchar and double
create class tb(
		col1 varchar,
		col2 double
);

insert into tb  values('varchar', 10);

select col1+col2 from tb;

drop class tb;

