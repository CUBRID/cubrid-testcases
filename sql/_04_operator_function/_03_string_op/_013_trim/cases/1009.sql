-- [er]retrieve by function of ltrim using three parameters

create class dummy( a int );
insert into dummy values (1);


select ltrim('''h''i', 'h', 'hihi') from dummy;



drop class dummy;