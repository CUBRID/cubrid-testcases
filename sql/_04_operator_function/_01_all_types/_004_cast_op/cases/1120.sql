--test cast function by casting double data type to string,varchar(10),varchar(20),int,numeric(38,10),float,double,monetary,nchar(20),nchar varying(20) data type ,and cast set{doublepretest} as set of numeric(38,10),list{doublepretest} as list of numeric(38),multiset{doublepretest} as multiset of numeric(38,10)

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
timestamptest           timestamp,
bittest         bit(16),
nchartest       nchar(20),
ncharvartest    nchar varying(20),
bitvartest              bit varying(20),
stringtest      string);
create class dummy( a int );
insert into func_03 values ( '1234567890', 123, 12345, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_03 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_03(stringtest) values ( null);
insert into dummy values (1);

select doublepretest from func_03	 order by 1;
select cast(doublepretest as string) from func_03 order by 1;
select cast(doublepretest as varchar(10)) from func_03	 order by 1;
select cast(doublepretest as varchar(20)) from func_03	 order by 1;
select cast(doublepretest as int) from func_03;	
select cast(doublepretest as numeric(38,10)) from func_03;	
select cast(doublepretest as float) from func_03;	
select cast(doublepretest as double) from func_03;	
select cast(doublepretest as monetary) from func_03;	
select cast(doublepretest as nchar(20)) from func_03;	
select cast(doublepretest as nchar varying(20)) from func_03;	
select cast(set{doublepretest} as set of numeric(38,10)) from func_03	 order by 1;
select cast(list{doublepretest} as list of numeric(38)) from func_03;	
select cast(multiset{doublepretest} as multiset of numeric(38,10)) from func_03 order by 1;

drop class func_03;
drop class dummy;
