--Test group by in partition of list partition class
create class t1 (col1 integer, 
                 col2 date, 
                 col3 char(10), 
                 col4 varchar(10),
                 col5 time,
                 col6 timestamp)
	PARTITION BY LIST (col1) (
	    PARTITION p0 VALUES IN (1001,1002,1003)
	);
insert into t1 values(1001, date'09/10/2008', 'char1','varchar101',TIME'16:08:33 pm',TIMESTAMP '8:15:00 PM 01/31/1994');
insert into t1 values(1002, date'09/10/2008', 'char1','varchar101',TIME'16:08:33 pm',TIMESTAMP '8:15:00 PM 01/31/1994');
insert into t1 values(1003, date'09/10/2008', 'char1','varchar101',TIME'16:08:33 pm',TIMESTAMP '8:15:00 PM 01/31/1994');

select max(col2), col1 from t1__p__p0
group by col1;
drop class t1;