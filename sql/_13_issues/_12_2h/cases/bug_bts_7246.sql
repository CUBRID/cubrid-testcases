autocommit off;
create class trigger_hi2 ( a int, b string , c blob, d clob);
create class tt2( a int, b string , c blob, d clob);
commit;
create trigger t_t1_insert
after insert on tt2
execute insert into trigger_hi2(a, b, c, d) values( obj.a ,clob_to_char(obj.d), obj.c, obj.d);

insert into tt2(a,b, c, d) values(2, 'test2', bit_to_blob(X'ddccbbaa'), char_to_clob('2test_clob'));
select a,b,blob_to_bit(c),clob_to_char(d) from trigger_hi2 order by 1;

rollback;
drop table trigger_hi2;
drop table tt2;

commit;
autocommit on;

