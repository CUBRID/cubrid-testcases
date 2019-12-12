--[er]Create serial with nocycle and reach the maxvalue and retrieve from db_serial
create serial test_serial
start with 10000001
increment by 2
nominvalue
maxvalue 10000006
nocycle;


create class test_class(col integer);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
select * from test_class;

select *
from   db_serial
where  name = 'test_serial';


drop class test_class;
drop serial test_serial;