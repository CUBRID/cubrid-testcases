--test operator || with nchar and time
create class tb(
		col1 nchar(6),
		col2 nchar varying(6),		
		col3 time
);

insert into tb  values(n'nchar', n'nvchar', '8:8:8 am');

select col1||col3 from tb;
select col2||col3 from tb;

drop class tb;

