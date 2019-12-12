--test greatest function with update statement.
create class tb(
		col1 varchar
);

insert into tb values('ok1');
insert into tb values('ok2');
insert into tb values('ok3');

update tb set col1='ok8' where greatest('ok4', col1) = 'ok4' ;

drop class tb;
