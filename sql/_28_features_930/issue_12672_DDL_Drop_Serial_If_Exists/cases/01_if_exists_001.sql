--01_if_exists_001.sql
--+ holdcas on;

--basic01
drop if exists s_test1;
drop serial if exists a_serial;
drop serial if exists b_serial;
drop serial if exists c_serial;
drop serial if exists d_serial;
drop serial if exists e_serial;
create class s_test1 ( a int, b int, c int, d blob, e clob);

create serial a_serial increment by  1;
create serial b_serial increment by  2;
create serial c_serial increment by  3;
create serial d_serial increment by  4;
create serial e_serial increment by  5;

insert into s_test1(a,b,c) values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);
insert into s_test1 values(a,b,c,d) ( a_serial.next_value, b_serial.next_value, c_serial.next_value, bit_to_blob(d_serial.next_value));
insert into s_test1 values(a,b,c,e) ( a_serial.next_value, b_serial.next_value, c_serial.next_value, char_to_clob(e_serial.next_value));
insert into s_test1(a,b,c,d,e) values ( a_serial.next_value, b_serial.next_value, c_serial.next_value,bit_to_blob(X'aaa'),char_to_clob('bbb'));

select a,b,c,blob_to_bit(d),clob_to_char(e) from s_test1 order by a;
select 'db_serial' TABLE_NAME, db_serial.* from db_serial where name='s_test1' order by 1,2,3,4,5,6,7,8,9,10,11; 

drop serial if exists a_serial;
drop serial if exists b_serial;
drop serial if exists c_serial;
drop serial if exists d_serial;
drop serial if exists e_serial;
delete from s_test1;

drop if exists s_test1;

--+ holdcas off;
commit;

