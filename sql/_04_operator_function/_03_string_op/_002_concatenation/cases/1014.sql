--[er]test operator || with nchar and string
create class tb(
		col1 nchar(6),
		col2 nchar varying(6),		
		col3 string
);

insert into tb  values(N'nchar', n'nvchar', 'string');

select col1||col3 from tb;
select col2||col3 from tb;

drop class tb;
