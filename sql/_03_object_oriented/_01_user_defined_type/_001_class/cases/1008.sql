--[er]test create with a table not previously defined

create class tb1(
	col1 int,
	col2 tb2
);

create class tb2(
	col1 int
);

drop class tb2;
drop class tb1;

