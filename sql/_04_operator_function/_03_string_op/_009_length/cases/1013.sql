--test length function using this function as where condition.
create class tb(
		col1 varchar
);

insert into tb values('a');
insert into tb values('aa');
insert into tb values('aaa');

select * from tb where length(col1)<3;

drop class tb;
