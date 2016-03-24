--TEST: [Pseudocolumn in DEFAULT clause] USER/CURRENT_USER cannot be used as the default value of a char(n) type column.


create table foo(
	a char(20) default USER, 
	b varchar(20) default USER,
	c char(20) default CURRENT_USER,
	d varchar default CURRENT_USER
);

show columns in foo;

insert into foo default;
insert into foo values(default, default, default, default);
insert into foo(a) values(default), (default), (default);


select if (a is not null and a=b and b=c and c=d, 'ok', 'nok') from foo;


drop table foo;
