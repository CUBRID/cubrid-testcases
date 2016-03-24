--[er]compare  date and time data type value by comparison operator '='

create class func_01(
datetest        date,
timetest        time,
timestamptest           timestamp
);
insert into func_01 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm');
insert into func_01 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/15/1977 5:35:00 pm');
insert into func_01 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/15/1977 02:10:00');
insert into func_01 values ( null, null, null);

select datetest, timetest, timestamptest from func_01 where datetest = timetest order by 1,2,3;

drop class func_01;
