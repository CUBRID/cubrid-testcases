--check lock release after semantic error

create class a ( a int primary key );

select * from a where a = 'a';

insert into a values(1);

select * from a;
drop a;
