-- create serial and table which insert data into using data type of string and int and test day in function of to_date using parameter of selected format and 'En_US' and then dorp table and serial 

create table day_test (
       u_day string,
       u_format string,
       lang string,
       ord int );
create serial ord start with 1 nocycle;
insert into day_test values ('2006-01-02-MONDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);                         
 insert into day_test values ('2006-01-03-TUESDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);                       
 insert into day_test values ('2006-01-04-WEDNESDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);                     
 insert into day_test values ('2006-01-05-THURSDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);                      
 insert into day_test values ('2006-01-06-FRIDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);                        
 insert into day_test values ('2006-01-07-SATURDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);                      
 insert into day_test values ('2006-01-08-SUNDAY','yyyy-mm-dd-DAY','En_US',ord.NEXT_VALUE);     
 
 insert into day_test values ('2006-01-02-Monday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);                         
 insert into day_test values ('2006-01-03-Tuesday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);                       
 insert into day_test values ('2006-01-04-Wednesday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);                     
 insert into day_test values ('2006-01-05-Thursday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);                      
 insert into day_test values ('2006-01-06-Friday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);                        
 insert into day_test values ('2006-01-07-Saturday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);                      
 insert into day_test values ('2006-01-08-Sunday','yyyy-mm-dd-Day','En_US',ord.NEXT_VALUE);     

 insert into day_test values ('2006-01-02-monday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE);                         
 insert into day_test values ('2006-01-03-tuesday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE);                       
 insert into day_test values ('2006-01-04-wednesday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE);                     
 insert into day_test values ('2006-01-05-thursday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE);                      
 insert into day_test values ('2006-01-06-friday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE);                        
 insert into day_test values ('2006-01-07-saturday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE);                      
 insert into day_test values ('2006-01-08-sunday','yyyy-mm-dd-day','En_US',ord.NEXT_VALUE); 
 insert into day_test values ('2006-01-02-MON','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-03-TUE','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-04-WED','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-05-THU','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-06-FRI','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-07-SAT','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-08-SUN','yyyy-mm-dd-DY','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-02-Mon','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-03-Tue','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-04-Wed','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-05-Thu','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-06-Fri','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-07-Sat','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-08-Sun','yyyy-mm-dd-Dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-02-mon','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-03-tue','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-04-wed','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-05-thu','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-06-fri','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-07-sat','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);                            
 insert into day_test values ('2006-01-08-sun','yyyy-mm-dd-dy','En_US',ord.NEXT_VALUE);
select u_day, u_format, to_date(u_day,u_format,'En_US') 
from day_test where  lang = 'En_US' order by ord;


drop table day_test;
drop serial ord;