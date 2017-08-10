autocommit off;
create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz, char_col varchar(20));

insert into test_class(datetime_col, char_col) values (datetimeltz '1-1-1 00:00:00.000', 'a');
insert into test_class(datetime_col, char_col) values (datetimeltz '0001-01-01 00:00:00.000', 'b');
insert into test_class(datetime_col, char_col) values (datetimeltz '1970-01-01 00:00:00.000', 'c');
insert into test_class(datetime_col, char_col) values (datetimeltz '1990-01-02 23:59:59.999', 'd');
insert into test_class(datetime_col, char_col) values (datetimeltz '2990-01-02 23:59:59.999', 'e');
insert into test_class(datetime_col, char_col) values (datetimeltz '1970-01-01 00:00:00', 'f');
insert into test_class(datetime_col, char_col) values (datetimeltz '1990-01-02 23:59:59', 'g');
insert into test_class(datetime_col, char_col) values (datetimeltz '2990-01-02 23:59:59', 'h');
insert into test_class(datetime_col, char_col) values (datetimeltz '01/01/1970 00:00:00.000', 'i');
insert into test_class(datetime_col, char_col) values (datetimeltz '01/02/1990 23:59:59.999', 'j');
insert into test_class(datetime_col, char_col) values (datetimeltz '01/02/2990 23:59:59.999', 'k');
insert into test_class(datetime_col, char_col) values (datetimeltz '01/01/1970 00:00:00', 'l');
insert into test_class(datetime_col, char_col) values (datetimeltz '01/02/1990 23:59:59', 'm');
insert into test_class(datetime_col, char_col) values (datetimeltz '01/02/2990 23:59:59', 'n');

select datetime_col || ' ' || char_col from test_class order by 1;
select date_col || ' ' || datetime_col from test_class order by 1;
select datetime_col || ' , OK' from test_class order by 1;
select 'datetimeltz: ' || datetime_col from test_class order by 1;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select datetime_col || ' ' || char_col from test_class order by 1;
select date_col || ' ' || datetime_col from test_class order by 1;
select datetime_col || ' , OK' from test_class order by 1;
select 'datetimeltz: ' || datetime_col from test_class order by 1;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

drop class test_class;
commit;
autocommit on;
