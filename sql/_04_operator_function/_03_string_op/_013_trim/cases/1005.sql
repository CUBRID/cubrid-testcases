-- [er]retrieve by function of rtrim using three parameters

create class dummy( a int );
insert into dummy values (1);


select rtrim('''h''i', 'h', 'hihi') from dummy;


drop class dummy;