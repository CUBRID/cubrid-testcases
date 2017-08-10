-- [er]retrieve by function of char_length using parameter of blank


create class dummy( a string );
insert into dummy values (null);

select char_length() from dummy;


drop class dummy;