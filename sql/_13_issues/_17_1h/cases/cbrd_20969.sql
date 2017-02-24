
select to_char(0, repeat('A', 16000)) from db_root;
select to_char(0, repeat('A', 16001)) from db_root;

select to_char(0, repeat('99.999EEEE', 10) , 'en_US');
select to_char(0, repeat('99.999EEEE', 1601) , 'en_US'); 

SET SYSTEM PARAMETERS 'intl_number_lang="de_DE"';
select to_char(0, repeat('99.999EEEE', 10));
select to_char(0, repeat('99,999EEEE', 10));
select to_char(1.234, repeat('99,999EEEE', 1601), 'de_DE');
SET SYSTEM PARAMETERS 'intl_number_lang="en_US"';


drop table if exists t;

create table t(type_char varchar);

insert into t values (repeat('99.999EEEE', 2000));
insert into t values ('S999999');

select to_char(1.234567 ,type_char) from t where type_char like '%99.999EEEE%';
select to_char(1234.567 ,type_char) from t where type_char='S999999';

drop table t;

