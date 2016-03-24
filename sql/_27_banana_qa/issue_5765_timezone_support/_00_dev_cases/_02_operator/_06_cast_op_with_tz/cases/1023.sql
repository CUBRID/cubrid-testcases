--test casting monetary to other type(like string, varchar, smallint, int, numeric, float, double, monetary, char, nchar varying)
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
timetest        datetimetz,
timestamptest           timestamptz,
bittest         bit(16),
nchartest       nchar(20),
ncharvartest    nchar varying(20),
bitvartest              bit varying(20),
stringtest      string);
create class dummy( a int );
insert into func_03 values ( '1234567890', 123, 12345, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/1977', datetimetz '2015-9-17 02:10:00', timestamptz '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_03 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_03(stringtest) values ( null);
insert into dummy values (1);


select moneytest from func_03 order by 1;	
select cast(moneytest as string) from func_03 order by 1;	
select cast(moneytest as varchar(10)) from func_03 order by 1;	
select cast(moneytest as varchar(20)) from func_03 order by 1;	
select cast(moneytest as smallint) from func_03 order by 1;	
select cast(moneytest as int) from func_03 order by 1;	
select cast(moneytest as numeric(38,10)) from func_03 order by 1;	
select cast(moneytest as float) from func_03 order by 1;	
select cast(moneytest as double) from func_03 order by 1;	
select cast(moneytest as monetary) from func_03 order by 1;	
select cast(moneytest as char(8)) from func_03 order by 1;	
select cast(moneytest as nchar(20)) from func_03 order by 1;	
select cast(moneytest as nchar varying(20)) from func_03 order by 1;	
select cast(set{moneytest} as set of numeric(38,10)) from func_03 order by 1;	
select cast(multiset{moneytest} as multiset of numeric(38,10)) from func_03 order by 1;	
select cast(list{moneytest} as list of numeric(38)) from func_03 order by 1;

drop class func_03;
drop class dummy;
