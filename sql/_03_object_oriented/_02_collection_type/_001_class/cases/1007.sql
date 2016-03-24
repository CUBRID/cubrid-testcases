--Test collection type
--Create class with collection type: set
create class t1(c1 set of integer, c2 set of varchar(10), 
                c3 set of date, c4 set of char(2),
                c5 set of timestamp, c6 set of bit(8));

insert into t1 values({1,2,3},{'abc','xxx','yyy','xxx'},
                       {date'05/12/2008', date'05/11/2008',date'05/11/2008'},
                       {'xx','yy','zz','xx','yy'},
                       {TIMESTAMP '01/31/1994 8:15:00 pm',
                        TIMESTAMP '01/31/1994 8:15:00 pm',
                        TIMESTAMP '01/21/1992 12:00:00 am'},
                       {B'0001',B'0010',B'0010'});
                       
select * from t1;
drop class t1;
