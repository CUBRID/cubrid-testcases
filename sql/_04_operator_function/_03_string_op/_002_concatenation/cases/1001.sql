-- [er]retrieve starting with "||" operator

create class dummy( a string);
insert into dummy values ('                    1');
insert into dummy values ('                    1');
insert into dummy values ('111');
insert into dummy values ('1      1');
insert into dummy values ('1        1');
insert into dummy values ('   1   ');
insert into dummy values (' 1 ');
insert into dummy values ('');
insert into dummy values (null);

select || 'hello' || 'world' from dummy order by 1;
 

drop class dummy;