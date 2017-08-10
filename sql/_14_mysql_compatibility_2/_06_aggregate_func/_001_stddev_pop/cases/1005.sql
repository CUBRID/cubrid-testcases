--test STDDEV_POP function with UNIQUE keyword and types int,float,double, monetary 
create class tb (
		varchartest     varchar(20),
		sinttest        smallint,
		inttest         int,
		numerictest     numeric(38,10),
		floattest       float,
		realtest        real,
		doublepretest   double precision,
		moneytest       monetary,
		chartest        char(8),
		datetest        date,
		timetest        time,
		timestamptest   timestamp,
		bittest         bit(16),
		nchartest       nchar(20),
		ncharvartest    nchar varying(20),
		bitvartest      bit varying(20),
		stringtest      string
);

insert into tb values ( '', 45, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into tb values ( '1', 56, 5, 5, 5, 5,5, 5, '', null, null, null,B'', N'', N'', B'','');
insert into tb values ( '-1234567890', 1523, -45, -9876543210987654321012345678.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into tb values ( '1234567890', 123, 45, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qatest');
insert into tb values ( '-1234567890', 5123, -45, -9876543210987654321012345678.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');
insert into tb values ( '1234567890', 123, 45, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qa test');

select STDDEV_POP(UNIQUE  inttest) from tb;
select STDDEV_POP(UNIQUE  floattest) from tb;
select STDDEV_POP(UNIQUE  realtest) from tb;
select STDDEV_POP(UNIQUE  doublepretest) from tb;
select STDDEV_POP(UNIQUE  moneytest) from tb;

drop class tb;
