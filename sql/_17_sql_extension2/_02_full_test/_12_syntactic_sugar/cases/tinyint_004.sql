--test display width syntax and zerofill attribute


create table tiny_int (col1 int, col2 tinyint(4), col3 tinyint(4) zerofill);


insert into tiny_int values(34, 34, 34);
insert into tiny_int values(-345, -345, -345);
insert into tiny_int values(34.244, 34.244, 34.244);
insert into tiny_int values(-5, -5, -5);
insert into tiny_int values(15896, 15896, 15896);


select * from tiny_int order by 1;

drop table tiny_int;



--??
create table tiny_int (col1 tinyint(20), col2 tinyint(200) zerofill);

insert into tiny_int values(234, 123);
insert into tiny_int values(234.23942893740912837412, 123.238974209384);
insert into tiny_int values(-3334, -32123);
insert into tiny_int values(234.00, 123.00);


select * from tiny_int order by 1;

drop table tiny_int;
