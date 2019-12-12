--test bit_length with operators(>,<,>=,<=,=,<>) and string as parameter of bit_length
create class tb(
		col1 string
);

insert into tb values('hello');
insert into tb values('hi');

select col1 from tb where bit_length(col1)>40 order by col1;
select col1 from tb where bit_length(col1)>=40 order by col1;
select col1 from tb where bit_length(col1)<40 order by col1;
select col1 from tb where bit_length(col1)<=40 order by col1;
select col1 from tb where bit_length(col1)=40 order by col1;
select col1 from tb where bit_length(col1)<>40 order by col1;


drop class tb;
