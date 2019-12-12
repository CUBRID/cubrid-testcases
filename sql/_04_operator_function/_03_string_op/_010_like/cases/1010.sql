--[er]test like function with escape keyword whose operand was two characters
create class tb(
	col1 varchar
);

insert into tb values('var%char');
insert into tb values('aa%a1');
insert into tb values('aa%%_a2');
insert into tb values('bb_b1');

select * from tb where col1 like '%[[_%' ESCAPE '[[';

drop class tb;

