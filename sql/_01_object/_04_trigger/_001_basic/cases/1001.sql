--test trigger using insert statement and two tables.
create class hi ( a int , b string );
create class tt1( a int, b string );
create trigger tt1_insert
after insert on tt1
execute insert into hi(a, b) values( obj.a ,to_char(obj.a));
insert into tt1(a,b) values(1, 'test');
select * from hi;
select * from tt1;


drop trigger tt1_insert;
drop class hi;
drop class tt1;
