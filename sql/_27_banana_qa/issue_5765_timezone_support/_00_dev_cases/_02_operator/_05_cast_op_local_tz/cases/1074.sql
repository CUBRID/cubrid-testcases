--test cast function by casting smallint data type to string,varchar(10),varchar(20),smallint,int,numeric,float,double,monetary,char(n),nchar(n),nchar varying(n) data type and casting set{sinttest} as set of int,multiset{sinttest} as multiset of int,list{sinttest} as list of int
set timezone '+9:00';

create class func_03(
varchartest     varchar(20),
sinttest         smallint,
inttest                 int,
numerictest     numeric(38,10),
floattest               float,
realtest                real,
doublepretest   double precision,
moneytest       monetary,
chartest        char(8),
datetest        date,
timetest        time,
timestamptest           timestampltz,
bittest         bit(16),
nchartest       nchar(20),
ncharvartest    nchar varying(20),
bitvartest              bit varying(20),
stringtest      string);
create class dummy( a int );
insert into func_03 values ( '1234567890', 123, 12345, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/1977', time '02:10:00', timestampltz '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_03 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_03(stringtest) values ( null);
insert into dummy values (1);

select sinttest from func_03 order by 1;	
select cast(sinttest as string) from func_03 order by 1;	
select cast(sinttest as varchar(10)) from func_03 order by 1;	
select cast(sinttest as varchar(20)) from func_03 order by 1;	
select cast(sinttest as smallint) from func_03	 order by 1;
select cast(sinttest as int) from func_03 order by 1;	
select cast(sinttest as numeric(38,10)) from func_03 order by 1;	
select cast(sinttest as float) from func_03 order by 1;	
select cast(sinttest as double) from func_03 order by 1;	
select cast(sinttest as monetary) from func_03 order by 1;	
select cast(sinttest as char(8)) from func_03 order by 1;	
select cast(sinttest as nchar(20)) from func_03 order by 1;	
select cast(sinttest as nchar varying(20)) from func_03 order by 1;	
select cast(set{sinttest} as set of int) from func_03 order by 1;	
select cast(multiset{sinttest} as multiset of int) from func_03 order by 1;
select cast(list{sinttest} as list of int) from func_03 order by 1;

drop class func_03;
drop class dummy;
set timezone 'default';
