--test operator + with varchar and smallint
create class tb(
		col1 varchar,
		col2 smallint
);

insert into tb  values('varchar', 10);

select col1+col2 from tb;

drop class tb;

