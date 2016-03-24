--test delete referenced class using drop statement

create class tb2(
	col1 char(8)
);

create class tb1(
	col1 int,
	col2 tb2
);


drop class tb1;
drop class tb2;


