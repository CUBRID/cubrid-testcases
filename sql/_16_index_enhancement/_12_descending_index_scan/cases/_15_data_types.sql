-- test with many data types

-- int
create table table_int(id int);

insert into table_int values(9910);
insert into table_int values(1253);
insert into table_int values(8535);
insert into table_int values(3443);
insert into table_int values(2532);
insert into table_int values(3564);
insert into table_int values(4335);
insert into table_int values(5473);
insert into table_int values(6556);
insert into table_int values(7866);

create index i_table_int_id on table_int(id);

select /*+ use_desc_idx */ id from table_int where id > 0;
select /*+ use_desc_idx */ id from table_int where id > 5000 limit 3;

drop table table_int;


-- float
create table table_float(id float);

insert into table_float values(99.10);
insert into table_float values(12.53);
insert into table_float values(85.35);
insert into table_float values(34.43);
insert into table_float values(25.32);
insert into table_float values(35.64);
insert into table_float values(43.35);
insert into table_float values(54.73);
insert into table_float values(65.56);
insert into table_float values(78.66);

create index i_table_float_id on table_float(id);

select /*+ use_desc_idx */ id from table_float where id > 0;
select /*+ use_desc_idx */ id from table_float where id > 50 limit 3;

drop table table_float;


-- varchar
create table table_varchar(text varchar);

insert into table_varchar values('awhgyzmyzt');
insert into table_varchar values('bolrvuuhll');
insert into table_varchar values('clzeohauuw');
insert into table_varchar values('dsvzsilzgx');
insert into table_varchar values('ejkdzpffjr');
insert into table_varchar values('fjsgpnxnzc');
insert into table_varchar values('gmiqkmsmsy');
insert into table_varchar values('hkcghxplze');
insert into table_varchar values('ioabpxfxao');
insert into table_varchar values('jxuucmvmiu');
insert into table_varchar values('kosgbyntqs');
insert into table_varchar values('ljqmukznup');
insert into table_varchar values('mwzonymcmk');
insert into table_varchar values('nrtbcsbmro');
insert into table_varchar values('olpwqwoovn');
insert into table_varchar values('pursvfqtyi');
insert into table_varchar values('qjyeibscxd');
insert into table_varchar values('rvvfjksbrn');
insert into table_varchar values('snvmqwvfki');
insert into table_varchar values('tcmlcyhpdd');
insert into table_varchar values('upgjmaqmvz');
insert into table_varchar values('wcwcbgnooe');
insert into table_varchar values('xbcbbuqrbo');
insert into table_varchar values('ylxsqbbhze');
insert into table_varchar values('zrjgzcdmrn');

create index i_table_varchar_text on table_varchar(text);

select /*+ use_desc_idx */ * from table_varchar where text > '';
select /*+ use_desc_idx */ * from table_varchar where text > 'm' limit 10;

drop table table_varchar;


-- date time
create table table_datetime(dt datetime);

insert into table_datetime values('02/01/2010');
insert into table_datetime values('10/29/2000');
insert into table_datetime values('04/13/2011');
insert into table_datetime values('06/05/1984');
insert into table_datetime values('03/19/1983');
insert into table_datetime values('01/05/1983');
insert into table_datetime values('05/10/1998');
insert into table_datetime values('11/14/1977');
insert into table_datetime values('01/19/2000');

create index i_table_datetime_dt on table_datetime(dt);

select /*+ recompile use_desc_idx */ * from table_datetime where dt > '01/01/1900';
select /*+ recompile */ * from table_datetime where dt > '01/01/1900';

drop table table_datetime;
