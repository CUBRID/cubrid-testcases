-- create table and test "||" and "+" operator and dorp table at last

create table dummy(a string, b string);
insert into dummy values ( 'Korea', 'Plaza Hotel' ); 
insert into dummy values ( 'Korea', 'Lotte Hotel' ); 
insert into dummy values ( 'Japan', 'dummy' );
select a || '  ' || b from dummy  order by 1;
select a + '  ' + b from dummy order by 1;
select a || 123 || 'test' from dummy order by 1;


drop table dummy;