-- trigger using insert statement and two tables.
create class trigger_hi ( a int, b string , c blob, d clob);
create class tt1( a int, b string , c blob, d clob);

create trigger tt1_insert
after insert on tt1
execute insert into trigger_hi(a, b, c, d) values( obj.a ,obj.b, obj.c, obj.d);

create trigger tt2_insert
after insert on tt1
execute insert into trigger_hi(a, b, c, d) values( obj.a ,obj.b, obj.c, obj.d);

insert into tt1(a,b, c, d) values(1, 'test', bit_to_blob(X'abcdef'), char_to_clob('test_clob'));
select a,b,blob_to_bit(c),clob_to_char(d) from trigger_hi;
select a,b,blob_to_bit(c),clob_to_char(d) from tt1;


drop trigger tt1_insert;
drop trigger tt2_insert;
delete from trigger_hi;
delete from tt1;
drop class trigger_hi;
drop class tt1;
