--test count function using select queries with some keywords such as 'unique', 'distinct', and also used many data types.
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

select count(sinttest), count(inttest), count(numerictest), count(floattest), count(realtest), count(doublepretest), count(moneytest) from func_09 order by 1;
select count(varchartest),count(chartest),count(nchartest), count(ncharvartest) , count(stringtest) from func_09 order by 1;
select count(datetest), count(timetest), count(timestamptest)   from func_09 order by 1;
select count(bittest), count(bitvartest) from func_09 order by 1;
select count(unique sinttest), count(unique inttest), count(unique numerictest), count(unique floattest), count(unique realtest), count(unique doublepretest), count(unique moneytest) from func_09 order by 1;
select count(unique varchartest),count(unique chartest),count(unique nchartest), count(unique ncharvartest) , count(unique stringtest) from func_09 order by 1;
select count(unique datetest), count(unique timetest), count(unique timestamptest)   from func_09 order by 1;
select count(unique bittest), count(unique bitvartest) from func_09 order by 1;
select count(distinct sinttest), count(distinct inttest), count(distinct numerictest), count(distinct floattest), count(distinct realtest), count(distinct doublepretest), count(distinct moneytest) from func_09 order by 1;
select count(distinct varchartest),count(distinct chartest),count(distinct nchartest), count(distinct ncharvartest) , count(distinct stringtest) from func_09 order by 1;
select count(distinct datetest), count(distinct timetest), count(distinct timestamptest)   from func_09 order by 1;
select count(distinct bittest), count(distinct bitvartest) from func_09 order by 1;
select count(all sinttest), count(all inttest), count(all numerictest), count(all floattest), count(all realtest), count(all doublepretest), count(all moneytest) from func_09 order by 1;
select count(all varchartest),count(all chartest),count(all nchartest), count(all ncharvartest) , count(all stringtest) from func_09 order by 1;
select count(all datetest), count(all timetest), count(all timestamptest)   from func_09 order by 1;
select count(all bittest), count(all bitvartest) from func_09 order by 1;

drop class func_09;
