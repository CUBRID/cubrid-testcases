-- [er]retrieve by function of rtrim using parameter of blank

create class dummy( a int );
insert into dummy values (1);


select rtrim() from dummy;



drop class dummy;