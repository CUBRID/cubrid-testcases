--[er]Create serial with minvalue 10000002(greater than the initial value)  and retrieve from db_serial(The min_val)
create serial test_serial
start with 10000001
increment by 2
minvalue 10000002;


create class test_class(col integer);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
insert into test_class values(test_serial.next_value);
select * from test_class;

select name, owner.name, started, increment_val,min_val
from   db_serial
where  name = 'test_serial';


drop class test_class;
drop serial test_serial;