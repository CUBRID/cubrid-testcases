-- [er]retrieve by function of substring using parameter of blank
create class dummy( a int );
insert into dummy values (1);


select substring() from dummy;

drop class dummy;