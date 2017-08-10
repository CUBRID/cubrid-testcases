--test display width syntax and zerofill attribute


create table medium_int (col1 int, col2 mediumint(8), col3 mediumint(8) zerofill);


insert into medium_int values(34, 34, 34);
insert into medium_int values(-345, -345, -345);
insert into medium_int values(34.244, 34.244, 34.244);
insert into medium_int values(-5, -5, -5);
insert into medium_int values(1589633, 1589633, 1589633);


select * from medium_int order by 1;

drop table medium_int;



--??
create table medium_int (col1 mediumint(50), col2 mediumint(200) zerofill);

insert into medium_int values(234, 123);
insert into medium_int values(234.23942893740912837412, 123.238974209384);
insert into medium_int values(-3334, -32123);
insert into medium_int values(234.00, 123.00);


select * from medium_int order by 1;

drop table medium_int;
