--test operator || with nchar and integer, smallint, monetary, float, double
create class tb(
		col1 nchar(6),
		col2 nchar varying(6),		
		col3 integer,
		col4 smallint,
		col5 monetary,
		col6 float,
		col7 double
);

insert into tb  values(n'nchar', n'nvchar', 3, 4, 5, 6.6, 7.7);

select col1||col3 from tb;
select col2||col3 from tb;

select col1||col4 from tb;
select col2||col4 from tb;

select col1||col5 from tb;
select col2||col5 from tb;

select col1||col6 from tb;
select col2||col6 from tb;

select col1||col7 from tb;
select col2||col7 from tb;

drop class tb;

