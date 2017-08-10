create table chars (_str string);
insert into chars values('\n\r\t\\');
insert into chars values('_numeric_30_10');
insert into chars values('87654321');
insert into chars values('Rest');
insert into chars values('~&');

select _str,(CASE WHEN ASCII(left(_str,1)) < 57 THEN CONCAT('3',_str)
                     WHEN ASCII(left(_str,1)) < 122 THEN CONCAT('2',_str)
                     ELSE CONCAT('1',_str)
                END) as results
from chars
order by 1;

	
drop table chars;