--test operator || with nchar and date
create class tb(
		col1 nchar(6),
		col2 nchar varying(6),		
		col3 date
);

insert into tb  values(n'nchar', n'nvchar', '5/5/2008');

select col1||col3 from tb;
select col2||col3 from tb;

drop class tb;
