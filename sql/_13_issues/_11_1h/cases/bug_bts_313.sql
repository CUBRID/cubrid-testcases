create class xoo (a int, b string);
insert into xoo values(1, '111');
insert into xoo values(2, '222');
prepare st from 'select a from xoo where a = to_number(?) and a = ?' execute st using '1', '1' drop prepare st;
prepare st from 'select a from xoo where a = to_number(?) and a = ?' execute st using '1', 1 drop prepare st;
select a from xoo where a = to_number('1') and a = 1;

drop table xoo;

