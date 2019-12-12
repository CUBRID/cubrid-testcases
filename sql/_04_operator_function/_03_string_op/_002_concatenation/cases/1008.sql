--test operator || with nchar and bit
create class tb(
		col1 nchar(6),
		col2 nchar varying(6),		
		col3 bit(4)
);

insert into tb  values(n'nchar', n'nvchar', b'0001');

select col1||col3 from tb;
select col2||col3 from tb;

drop class tb;

