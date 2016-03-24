--[er]test difference operator using two subqueries whose column is compatible
create class func_13(
a   varchar(20),
b   smallint,
c   int,
d   numeric(38,10),
e   float,
f    real,
g   double precision,
h      monetary,
i       char(8),
j      date,
k        time,
l           timestamp,
m         bit(16),
n       nchar(20),
o    nchar varying(20),
p              bit varying(20),
q      string);
insert into func_13 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_13 values ( '1', 5, 5, 5, 5, 5,5, 5, '', null, null, null,B'', N'', N'', B'','');
insert into func_13(a) values ( null);
insert into func_13 values ( '-1234567890', -123, -45, -9876543210987654321012345678.0123456789, -987654.321, -987654321.987654321,-987654.321, -9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111',B'1','qa test');
insert into func_13 values ( '1234567890', 123, 45, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qatest');
insert into func_13 values ( '-1234567890', -123, -45, -9876543210987654321012345678.0123456789, -987654.321, -987654321.987654321,-987654.321,-9876.1,'-char123', DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm',B'0', N'test111', N'test111',B'1','qa test');
insert into func_13 values ( '1234567890', 123, 45, 9876543210987654321012345678.0123456789, 987654.321, 987654321.987654321,987654.321, 9876.1,'char1234', DATE '08/14/2000', TIME '00:10:00', TIMESTAMP '08/14/2000 5:35:00 pm',B'0', N'test111', N'test111', B'1','qatest');
insert into func_13 values ( '', 0, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');
insert into func_13(a) values ( null);

select  a from func_13 difference select cast(a as int) from func_13 order by 1;

drop table func_13;
