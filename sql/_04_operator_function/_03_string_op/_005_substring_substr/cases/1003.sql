
-- [er]retrieve by function of substring without from keyword

create class dummy( a int );
insert into dummy values (1);


select substring(abc) from dummy;


drop class dummy;