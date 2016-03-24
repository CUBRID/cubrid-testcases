--test min function with the operator(like distinct, all) and  the data type(like varchar, char, nchar, date, time, timestamp, numeric, bit, bit varying...)
create class func_09(
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
insert into func_09 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_09 values ( '1', 5, 5, 5, 5, 5,5, 5, '', null, null, null,B'', N'', N'', B'','');
insert into func_09(stringtest) values ( null);
insert into func_09 values ( '-1234567890', -123, -45, -9876543210987654321012345678.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_09 values ( '1234567890', 123, 45, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qatest');
insert into func_09 values ( '-1234567890', -123, -45, -9876543210987654321012345678.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_09 values ( '1234567890', 123, 45, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_09 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_09(stringtest) values ( null);


select min(varchartest),min(chartest),min(nchartest), min(ncharvartest) , min(stringtest) from func_09 order by 1;
select min(datetest), min(timetest), min(timestamptest)   from func_09 order by 1;
select min(bittest), min(bitvartest) from func_09	 order by 1;
select min(unique varchartest),min(unique chartest),min(unique nchartest), min(unique ncharvartest) , min(unique stringtest) from func_09 order by 1;
select min(unique datetest), min(unique timetest), min(unique timestamptest)   from func_09 order by 1;
select min(unique bittest), min(unique bitvartest) from func_09 order by 1;
select min(distinct varchartest),min(distinct chartest),min(distinct nchartest), min(distinct ncharvartest) , min(distinct stringtest) from func_09 order by 1;
select min(distinct datetest), min(distinct timetest), min(distinct timestamptest)   from func_09 order by 1;
select min(distinct bittest), min(distinct bitvartest) from func_09 order by 1;
select min(all varchartest),min(all chartest),min(all nchartest), min(all ncharvartest) , min(all stringtest) from func_09 order by 1;
select min(all datetest), min(all timetest), min(all timestamptest)   from func_09 order by 1;
select min(all bittest), min(all bitvartest) from func_09 order by 1;
select numerictest, min(numerictest) from func_09 group by numerictest order by 1;
select numerictest, avg(cast(numerictest as numeric(38,0))) from func_09 group by numerictest order by 1;

drop class func_09;
