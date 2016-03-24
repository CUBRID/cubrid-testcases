--test '+','-' operators by operating between DATE,TIME,TIMESTAMP data type 

create class func_02(
a      date,
b      time,
c      timestamp
);
insert into func_02 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm');
insert into func_02 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/15/1977 5:35:00 pm');
insert into func_02 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/15/1977 02:10:00');
insert into func_02 values ( null, null, null);

select a, a + 10, a+100, a-20, a-365   from func_02 order by 1;	
select b, b + 60, b - 3600, b + 36000 from func_02 order by 1;	
select c, c + 60, c - 3600, c + 36000 from func_02 order by 1;	
select a - a from func_02 order by 1;	
select b - b from func_02 order by 1;	
select c - c from func_02 order by 1;

drop class func_02;
