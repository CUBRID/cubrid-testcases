-- [er]create class,insert data to this class,select clause with an error 'Syntax: please check syntax at '(', expecting { qualified name } in path expression.'

create class xoo ( a int);
insert into xoo values(100);

select incr( ( select b from xoo where a = 100) ) from xoo where a = 100;

drop xoo;
