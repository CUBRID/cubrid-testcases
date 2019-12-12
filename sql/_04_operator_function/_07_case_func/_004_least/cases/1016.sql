--test least function with delete statement.
create class tb(
		col1 varchar
);

insert into tb values('ok1');
insert into tb values('ok2');
insert into tb values('ok3');

delete from tb where least('ok3', col1) = 'ok3';

drop class tb;
