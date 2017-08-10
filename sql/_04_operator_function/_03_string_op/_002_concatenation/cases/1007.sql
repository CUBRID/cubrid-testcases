--[er]test operator || with nchar and char
create class tb(
		col1 nchar(6),
		col2 nchar varying(6),		
		col3 char(8)
);

insert into tb  values(N'nchar', n'nvchar', 'varchar');

select col1||col3 from tb;
select col2||col3 from tb;

drop class tb;

