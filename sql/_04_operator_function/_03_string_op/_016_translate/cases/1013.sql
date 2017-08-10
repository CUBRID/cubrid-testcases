--test translate function using it as column's expression.
create class tb(
		col1 varchar
);

insert into tb values('abc1');
insert into tb values('abc2');
insert into tb values('abc3');

select translate(col1, 'ab', '23') from tb order by 1;

drop class tb;
