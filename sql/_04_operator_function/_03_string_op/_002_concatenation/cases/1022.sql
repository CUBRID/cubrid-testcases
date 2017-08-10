--test operator + with varchar and date
create class tb(
		col1 varchar,
		col2 date
);

insert into tb  values('varchar', '5/5/2008');

select col1+col2 from tb;

drop class tb;

