--test operator + with varchar and float
create class tb(
		col1 varchar,
		col2 float
);

insert into tb  values('varchar', 10);

select col1+col2 from tb;

drop class tb;

