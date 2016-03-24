--Create a serial with default attribute and retrieve information from db_serail
create serial test_serial;

select * from db_serial
where name = 'test_serial';

drop serial test_serial;
