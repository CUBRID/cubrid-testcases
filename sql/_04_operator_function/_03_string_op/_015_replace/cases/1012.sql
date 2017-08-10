--test replace using a class and two select queries. 
create class tb(
	col1 varchar
);

insert into tb values('abc');
insert into tb values('abcd');

select replace(col1, 'ab', '33') from tb;
select replace(col1, 'abs', '66') from tb;

drop class tb;
