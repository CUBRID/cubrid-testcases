--test sum function with the operator(like distinct, unique) and the data type(like smallint, int, numeric, float, real, double, monetary)
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
insert into func_09 values ( '-1234567890', -123, -45, -987654321098765432101234567.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_09 values ( '1234567890', 123, 45, 987654321098765432101234567.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qatest');
insert into func_09 values ( '-1234567890', -123, -45, -987654321098765432101234567.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_09 values ( '1234567890', 123, 45, 987654321098765432101234567.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into func_09 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_09(stringtest) values ( null);

select sum(sinttest), sum(inttest), sum(numerictest), sum(floattest), sum(realtest), sum(doublepretest), sum(moneytest) from func_09 order by 1;
select sum(unique sinttest), sum(unique inttest), sum(unique numerictest), sum(unique floattest), sum(unique realtest), sum(unique doublepretest), sum(unique moneytest) from func_09 order by 1;
select sum(distinct sinttest), sum(distinct inttest), sum(distinct numerictest), sum(distinct floattest), sum(distinct realtest), sum(distinct doublepretest), sum(distinct moneytest) from func_09 order by 1;
select sum(all sinttest), sum(all inttest), sum(all numerictest), sum(all floattest), sum(all realtest), sum(all doublepretest), sum(all moneytest) from func_09 order by 1;

drop class func_09;
