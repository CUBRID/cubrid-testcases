-- create two tables hi,tt1,create trigger based on after insert on tt1,insert data to tt1, select data from hi and tt1 for testing,drop trigger and tables at last

create class hi ( a int , b string );
create class tt1( a int, b string );
create trigger tt1_insert
after insert on tt1
execute insert into hi(a, b) values( obj.a ,to_char(obj.a));
insert into tt1(a,b) values(1, 'test');
select * from hi;
select * from tt1;


drop trigger tt1_insert;
drop class tt1;
drop class hi;