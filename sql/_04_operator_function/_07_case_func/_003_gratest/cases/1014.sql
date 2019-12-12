--test greatest function with wehre condition.
create class tb(
		col1 varchar
);

insert into tb values('ok1');
insert into tb values('ok2');
insert into tb values('ok3');

select * from tb where greatest('ok4', col1) ;

drop class tb;


