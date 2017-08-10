--test operator + with int, smallint, numeric, monetary, float, double
create class tb(
		col1 int,
		col2 smallint,
		col3 numeric,
		col4 monetary,
		col5 float,
		col6 double
);

insert into tb  values(3, 4, 5.5, 6, 7.7, 8.8);

select col1+col2 from tb;
select col1+col3 from tb;
select col1+col4 from tb;
select col1+col5 from tb;
select col1+col6 from tb;

select col2+col3 from tb;
select col2+col4 from tb;
select col2+col5 from tb;
select col2+col6 from tb;

select col3+col4 from tb;
select col3+col5 from tb;
select col3+col6 from tb;

select col4+col5 from tb;
select col4+col6 from tb;

select col5+col6 from tb;

drop class tb;

