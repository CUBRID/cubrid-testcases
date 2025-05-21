--+ holdcas on;
--inet_aton_ntoa_basic_negative.sql

select inet_aton('8.9.10.11.12');
prepare y from 'select inet_aton(?)';
execute y using '1.2';
deallocate prepare y;
select inet_aton('400.300.200.100');
select inet_aton(123.5);
select inet_ntoa(0x2356);
select inet_ntoa('test');
select inet_ntoa(-55);
select 999999999999 into temp;
select inet_ntoa(:temp);

select inet_aton(:undeflabel);

drop table if exists test;

create table test (a BIGINT UNIQUE PRIMARY KEY, b varchar(20));
insert test values(inet_aton('1.2.3.4'),'1.2.3.4');
select inet_ntoa('select a from test where a<6');
create index ntoa_abs on test(inet_ntoa(abs(a)));
create index dummy on test(inet_ntoa(a + 1));
create index invalid_index on test(inet_aton(b));

drop table if exists test;



--+ holdcas off;
