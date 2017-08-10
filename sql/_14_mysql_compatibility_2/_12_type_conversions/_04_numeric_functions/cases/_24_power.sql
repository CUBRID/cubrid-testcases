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
numeric_col NUMERIC(12,4),
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

insert into alltypes values(12, 1.4, 2.367, 2, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.2 am',2, 6.7890, '2', '1.4' ,N'1.4', N'2', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '2', '2');


select if(floor(power(monetary_col,2.23)) = floor(power($2.00,2.23)), 'ok', 'nok') from alltypes;

select if(floor(power(2.23,monetary_col)) = floor(power(2.23,$2.00)), 'ok', 'nok') from alltypes;

select if(floor(power(monetary_col,monetary_col)) = floor(power($2.00,$2.00)), 'ok', 'nok') from alltypes;

select if(floor(power(monetary_col,char_col)) = floor(power($2.00,'2')), 'ok', 'nok') from alltypes;

select if(floor(power(monetary_col,varchar_col)) = floor(power($2.00,'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(monetary_col,nchar_col)) = floor(power($2.00,n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(monetary_col,varnchar_col)) = floor(power($2.00,N'2')), 'ok', 'nok') from alltypes;


select if(floor(power(numeric_col,2.23)) = floor(power(6.7890,2.23)), 'ok', 'nok') from alltypes;

select if(floor(power(2.23,numeric_col)) = floor(power(2.23,6.7890)), 'ok', 'nok') from alltypes;

select if(floor(power(numeric_col,char_col)) = floor(power(6.7890,'2')), 'ok', 'nok') from alltypes;

select if(floor(power(numeric_col,varchar_col)) = floor(power(6.7890,'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(numeric_col,nchar_col)) = floor(power(6.7890,n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(numeric_col,varnchar_col)) = floor(power(6.7890,N'2')), 'ok', 'nok') from alltypes;

select if(floor(power(numeric_col,numeric_col)) = floor(power(6.7890,6.7890)), 'ok', 'nok') from alltypes;


select if(floor(power(char_col,2.23)) = floor(power('2',2.23)), 'ok', 'nok') from alltypes;

select if(floor(power(2.23,char_col)) = floor(power(2.23,'2')), 'ok', 'nok') from alltypes;

select if(floor(power(char_col,char_col)) = floor(power('2','2')), 'ok', 'nok') from alltypes;

select if(floor(power(char_col,monetary_col)) = floor(power('2',$2.00)), 'ok', 'nok') from alltypes;

select if(floor(power(char_col,numeric_col)) = floor(power('2',6.7890)), 'ok', 'nok') from alltypes;

select if(floor(power(char_col,varchar_col)) = floor(power('2','1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(char_col,nchar_col)) = floor(power('2',n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(char_col,varnchar_col)) = floor(power('2',N'2')), 'ok', 'nok') from alltypes;


select if(floor(power(varchar_col,2.23)) = floor(power('1.4',2.23)), 'ok', 'nok') from alltypes;

select if(floor(power(2.23,varchar_col)) = floor(power(2.23,'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(varchar_col,varchar_col)) = floor(power('1.4','1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(varchar_col,monetary_col)) = floor(power('1.4',$2.00)), 'ok', 'nok') from alltypes;

select if(floor(power(varchar_col,numeric_col)) = floor(power('1.4',6.7890)), 'ok', 'nok') from alltypes;

select if(floor(power(varchar_col,varchar_col)) = floor(power('1.4','1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(varchar_col,nchar_col)) = floor(power('1.4',n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(varchar_col,varnchar_col)) = floor(power('1.4',N'2')), 'ok', 'nok') from alltypes;


select if(floor(power(nchar_col,2.23)) = floor(power(n'1.4',2.23)), 'ok', 'nok') from alltypes;

select if(floor(power(2.23,nchar_col)) = floor(power(2.23,n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(nchar_col,monetary_col)) = floor(power(n'1.4',$2.00)), 'ok', 'nok') from alltypes;

select if(floor(power(nchar_col,numeric_col)) = floor(power(n'1.4',6.7890)), 'ok', 'nok') from alltypes;

select if(floor(power(nchar_col,varchar_col)) = floor(power(n'1.4','1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(nchar_col,nchar_col)) = floor(power(n'1.4',n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(nchar_col,varnchar_col)) = floor(power(n'1.4',N'2')), 'ok', 'nok') from alltypes;


select if(floor(power(varnchar_col,2.23)) = floor(power(N'2',2.23)), 'ok', 'nok') from alltypes;

select if(floor(power(2.23,varnchar_col)) = floor(power(2.23,N'2')), 'ok', 'nok') from alltypes;

select if(floor(power(varnchar_col,monetary_col)) = floor(power(N'2',$2.00)), 'ok', 'nok') from alltypes;

select if(floor(power(varnchar_col,numeric_col)) = floor(power(N'2',6.7890)), 'ok', 'nok') from alltypes;

select if(floor(power(varnchar_col,varchar_col)) = floor(power(N'2','1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(varnchar_col,nchar_col)) = floor(power(N'2',n'1.4')), 'ok', 'nok') from alltypes;

select if(floor(power(varnchar_col,varnchar_col)) = floor(power(N'2',N'2')), 'ok', 'nok') from alltypes;

select if(power('2','10.5') = power(2,10.5), 'ok','nok');

select if(power('1.4',N'10.5') = power(1.4,10.5), 'ok','nok');

select if(power(N'2',N'10.5') = power(2,10.5),'ok','nok');

select if(power(N'1.4','10.5') = power(1.4,10.5),'ok','nok');

$varchar, $2, $varchar, $12.3
select power(?,?) from db_root;

$varchar, $2, $varchar, $12.3
select if (power(?,?) = power(2,12.3), 'ok','nok') from db_root;

drop table alltypes;



