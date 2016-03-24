--test avg funcion with the types smallint, int, numeric, real, double precision and monetary
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

select avg(sinttest), avg(inttest), avg(numerictest), avg(floattest), avg(realtest), avg(doublepretest), avg(moneytest) from func_09 order by 1;

select avg(unique sinttest), avg(unique inttest), avg(unique numerictest), avg(unique floattest), avg(unique realtest), avg(unique doublepretest), avg(unique moneytest) from func_09;	
select avg(distinct sinttest), avg(distinct inttest), avg(distinct numerictest), avg(distinct floattest), avg(distinct realtest), avg(distinct doublepretest), avg(distinct moneytest) from func_09;	
select avg(all sinttest), avg(all inttest), avg(all numerictest), avg(all floattest), avg(all realtest), avg(all doublepretest), avg(all moneytest) from func_09 order by 1;

drop class func_09;

