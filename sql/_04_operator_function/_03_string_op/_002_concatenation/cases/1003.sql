-- [er]retrieve starting with "||" operator

create class dummy( a string);
insert into dummy values ('adbc');
insert into dummy values ('1111');
insert into dummy values ('111');
insert into dummy values ('111111111');
insert into dummy values ('14424');
insert into dummy values ('1412');
insert into dummy values ('1421');
insert into dummy values ('');
insert into dummy values (null);
 
select || 'hello' || 'world' from dummy order by 1;

 

drop class dummy;