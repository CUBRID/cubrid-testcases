autocommit off;
create class dummy ( a int , b string );
insert into dummy values ( 10000, 'hi');
select a, to_char(a,'s99999') from dummy ; 
select a, to_char(a,'c99999') from dummy ;
select a, to_char(a,'S99999') from dummy ;
select a, to_char(a,'C99999') from dummy ;
rollback work;
rollback;
