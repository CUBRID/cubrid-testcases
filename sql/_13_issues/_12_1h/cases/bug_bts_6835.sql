-- test several functions as function index
create table t (a string);
create index idx on t(length(a));
drop t;

create table t (a string);
create index idx on t(char_length(a));
drop t;

create table t (a string);
create index idx on t(character_length(a));
drop t;

create table t (a string);
create index idx on t(lengthb(a));
drop t;

create table t (a string);
create index idx on t(bit_length(a));
drop t;

create table t (a string);
create index idx on t(octet_length(a));
drop t;

create table t (a char(10), b varchar(10), c int);
-- should give an error
create index idx_invalid on t(COALESCE(a,b,c,'constant'));
drop t;

create table t (a string, b string);
-- next index should give an error
create index idx_invalid1 on t(concat_ws(' ',a,b,a,b));
-- next index should give an error
create index idx_invalid2 on t(decode(a,b,'abc','cde'));
create index idx3 on t(ifnull(a,b));
create index idx4 on t(nvl(a,b));
create index idx5 on t(nvl2(a,b,'a is null'));
create index idx6 on t(nullif(a,b));
-- next index should give an error
create index idx_invalid7 on t(field(a,b,'abc','def','ghi'));
create index idx8 on t(locate(a,b));
create index idx9 on t(substring(a,1,2));
create index idx10 on t(substr(a,1,2));
create index idx11 on t(to_char(a));
create index idx12 on t(to_date(a));
create index idx13 on t(to_datetime(a));
create index idx14 on t(to_time(a));
create index idx15 on t(to_timestamp(a));
create index idx16 on t(to_number(a));
create index idx17 on t(trim(a));
-- next index should give an error
create index idx_invalid18 on t(default(a));
drop t;

create table t (a date, b date);
create index idx1 on t(datediff(a,b));
drop t;

create table t (a int, b int);
-- should give an error
create index idx_invalid on t(if(a,b,-b));
drop t;