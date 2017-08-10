CREATE table alltypes(
int_col INTEGER,
float_col FLOAT,
double_col DOUBLE,
smallint_col SMALLINT,
date_col DATE,
time_col TIME,
timestamp_col TIMESTAMP,
datetime_col DATETIME,
monetary_col MONETARY,
numeric_col NUMERIC(12,3),
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255),
bit_col bit(8),
varbit_col bit varying (255),
set_col set(integer),
sequence_col sequence(integer),
multiset_col multiset(integer, varchar(255)),
blob_col blob,
clob_col clob
);

insert into alltypes values(1, 0.56, 0.85, 0, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1, 0.123, '0.45', '0.56' ,N'0.56', N'0.45', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');


select if (acos(monetary_col) = acos($1), 'ok','nok') from alltypes;

select if(acos(numeric_col) = acos(0.123), 'ok', 'nok') from alltypes;

select if(acos(char_col) = acos('0.45'), 'ok', 'nok') from alltypes;

select if(acos(varchar_col) = acos('0.56'), 'ok', 'nok') from alltypes;

select if(acos(nchar_col) = acos(N'0.56'), 'ok', 'nok') from alltypes;

select if(acos(varnchar_col) = acos(N'0.45'), 'ok', 'nok') from alltypes;

select if(acos('0.123') = acos(0.123), 'ok','nok');

select if(acos('0.45') = acos(0.45), 'ok','nok');

select if(acos(N'0.123') = acos(0.123),'ok','nok');

select if(acos(N'0.45') = acos(0.45),'ok','nok');

$varchar, $0.123
select acos(?) from db_root;

$varchar, $-0.123
select if (acos(?) = acos(-0.123), 'ok','nok') from db_root;

select acos(date'2010-01-01');

select acos('2010-01-01');

drop table alltypes;
