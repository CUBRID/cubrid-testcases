-- trigger using insert statement and two tables.
create class trigger_hi2 ( a int, b string , c blob, d clob);
create class tt2( a int, b string , c blob, d clob);

create trigger t_t1_insert
after insert on tt2
execute insert into trigger_hi2(a, b, c, d) values( obj.a ,clob_to_char(obj.a), obj.c, obj.d);

create trigger t_t2_insert
after insert on tt2
execute update trigger_hi2 set b=obj.b, c=obj.c, d=obj.d  where a=obj.a;

create trigger t_t3_insert
after insert on tt2
execute delete from trigger_hi2 where blob_to_bit(c)=blob_to_bit(obj.c) and clob_to_char(d)=clob_to_char(obj.d);

insert into tt2(a,b, c, d) values(1, 'test1', bit_to_blob(X'aabbccdd'), char_to_clob('1test_clob'));
select a,b,blob_to_bit(c),clob_to_char(d) from trigger_hi2 order by 1;
select a,b,blob_to_bit(c),clob_to_char(d) from tt2 order by 1;

drop trigger t_t3_insert;

insert into tt2(a,b, c, d) values(2, 'test2', bit_to_blob(X'ddccbbaa'), char_to_clob('2test_clob'));
select a,b,blob_to_bit(c),clob_to_char(d) from trigger_hi2 order by 1;
select a,b,blob_to_bit(c),clob_to_char(d) from tt2 order by 1;


drop trigger t_t1_insert;
drop trigger t_t2_insert;

delete from trigger_hi2;
delete from tt2;
drop class trigger_hi2;
drop class tt2;
