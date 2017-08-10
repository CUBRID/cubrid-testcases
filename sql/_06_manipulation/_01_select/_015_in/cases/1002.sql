--Test numeric data type using key of in

create class scale_t (n numeric(5,2));
insert into scale_t values (123.45);
select * from scale_t where n in ( 123.45 ) order by 1;
select * from scale_t where 123.45 in ( n ) order by 1;

drop table scale_t;
