--test operator + with varchar and bit, bit varying
create class tb(
		col1 varchar,
		col2 bit(8),
		col3 bit varying(8)
);

insert into tb  values('varchar', b'0001', b'0001');

select col1+col2 from tb;
select col1+col3 from tb;

drop class tb;

