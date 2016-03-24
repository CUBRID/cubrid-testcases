
select  1 from db_root where unix_timestamp('1')  >1;
select  1 from db_root where unix_timestamp('10')  >1; 
select  1 from db_root where unix_timestamp('105')  >1;
select  1 from db_root where unix_timestamp('1005')  >1;
select  1 from db_root where unix_timestamp('10050106')  >1;


select 1 from db_root where  unix_timestamp('10051') between 1272639600-24*3600 and 1272639600+24*3600;
select 1 from db_root where  unix_timestamp('100501') between 1272639600-24*3600 and 1272639600+24*3600;
select 1 from db_root where   unix_timestamp('20100501') between 1272639600-24*3600 and 1272639600+24*3600;
select 1 from db_root where   unix_timestamp('20100501000000') between 1272639600-24*3600 and 1272639600+24*3600;

select 1 from db_root where  unix_timestamp('1005016') > unix_timestamp('100501');
select 1 from db_root where unix_timestamp('20100501060000')>unix_timestamp('20100501000000');
select  1 from db_root where unix_timestamp('100501061')  >1;
select  1 from db_root where unix_timestamp('1005010601')  >1;
select  1 from db_root where unix_timestamp('20100501060100')  >1;

select  1 from db_root where unix_timestamp('10050106011')  >1;
select  1 from db_root where unix_timestamp('100501060101')  >1;
select  1 from db_root where unix_timestamp('1005010601011')  >1;
select  1 from db_root where unix_timestamp('1005010601012')  >1;
select  1 from db_root where unix_timestamp('20100501060101')  >1;
select  1 from db_root where unix_timestamp('201005010601011')  >1;
select  1 from db_root where unix_timestamp('201005010601012')  >1;
select  1 from db_root where unix_timestamp('2010050106010111')  >1;
select  1 from db_root where unix_timestamp('2010050106010122')  >1;


select  1 from db_root where unix_timestamp('100501a')  >1;
select  1 from db_root where unix_timestamp('10050106a')  >1;
select  1 from db_root where unix_timestamp('1005010601a')  >1;
select  1 from db_root where unix_timestamp('100501060101a')  >1;
select  1 from db_root where unix_timestamp('20100501a')  >1;
select  1 from db_root where unix_timestamp('2010050106a')  >1;
select  1 from db_root where unix_timestamp('201005010601a')  >1;
select  1 from db_root where unix_timestamp('20100501060101a')  >1;


select  1 from db_root where unix_timestamp('1-1-1')  >1; 
select  1 from db_root where unix_timestamp('2-2-2')  >1; 

select  1 from db_root where unix_timestamp('01-1-1')  >1;
select  1 from db_root where unix_timestamp('01-1-1a')  >1;
select  1 from db_root where unix_timestamp('01-1-1 ')  >1;
select  1 from db_root where unix_timestamp('01-01-1')  >1;
select  1 from db_root where unix_timestamp('01-01-01')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:0')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:0:')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:0:0')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:0:0.a')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:0:0.abc')  >1;
select  1 from db_root where unix_timestamp('01-01-01 0:0:0abc')  >1;

select  1 from db_root where unix_timestamp('2001-01-01')  >1;                                                                              
select  1 from db_root where unix_timestamp('2001-01-01a')  >1;                                                                             
select  1 from db_root where unix_timestamp('2001-01-01 ')  >1;                                                                             
select  1 from db_root where unix_timestamp('2001-01-01 0')  >1;                                                                            
select  1 from db_root where unix_timestamp('2001-01-01 0:')  >1;                                                                           
select  1 from db_root where unix_timestamp('2001-01-01 0:0')  >1;                                                                          
select  1 from db_root where unix_timestamp('2001-01-01 0:0:')  >1;                                                                         
select  1 from db_root where unix_timestamp('2001-01-01 0:0:0')  >1;                                                                        
select  1 from db_root where unix_timestamp('2001-01-01 0:0:0.')  >1;                                                                       
select  1 from db_root where unix_timestamp('2001-01-01 0:0:0.a')  >1;                                                                      
select  1 from db_root where unix_timestamp('2001-01-01 0:0:0.abc')  >1;                                                                    
select  1 from db_root where unix_timestamp('2001-01-01 0:0:0abc')  >1;                                                                     
select  1 from db_root where unix_timestamp('2001-01-01 00:00:00')  >1;   


select  1 from db_root where unix_timestamp('001-01-01')  >1;                                                                               
select  1 from db_root where unix_timestamp('0001-01-01')  >1;                                                                              
select  1 from db_root where unix_timestamp('00001-01-01')  >1;              

select  1 from db_root where unix_timestamp('01-1-1 6:1:1')  >1;                                                                            
select  1 from db_root where unix_timestamp('01-01-1 6:1:1')  >1;                                                                           
select  1 from db_root where unix_timestamp('01-01-01 6:1:1')  >1;                                                                          
select  1 from db_root where unix_timestamp('01-01-01 06:1:1')  >1;                                                                         
select  1 from db_root where unix_timestamp('01-01-01 06:01:1')  >1;                                                                        
select  1 from db_root where unix_timestamp('01-01-01 06:01:01')  >1;                   

select  1 from db_root where unix_timestamp('01-1-01 06:01:01')  >1;                                                                        
select  1 from db_root where unix_timestamp('01-01-1 06:01:01')  >1;                                                                        
select  1 from db_root where unix_timestamp('01-1-1  06:01:01')  >1;                                                                        
select  1 from db_root where unix_timestamp('01-01-01 6:01:01')  >1;                                                                        
select  1 from db_root where unix_timestamp('01-01-01 06:1:01')  >1;                                                                        
select  1 from db_root where unix_timestamp('01-01-01 06:01:1')  >1;                     

select  1 from db_root where unix_timestamp('01-0001-0001   0000006:0000001:0000001')  >1;                                                  
select  1 from db_root where unix_timestamp('01-00001-00001 0000006:0000001:0000001')  >1;                                                  

select  1 from db_root where unix_timestamp('2001-1-1 6:1:1')  >1;                                                                          
select  1 from db_root where unix_timestamp('2001-01-01 06:01:01')  >1;                                                                     
select  1 from db_root where unix_timestamp('02001-01-01 06:01:01')  >1;                                                                    
select  1 from db_root where unix_timestamp('002001-01-01 06:01:01')  >1; 


select  1 from db_root where unix_timestamp('0020010-01-01 06:01:01')  >1;                                                                  
select  1 from db_root where unix_timestamp('002001a-01-01 06:01:01')  >1;   

select  1 from db_root where unix_timestamp('70-01-01 12:00:00')  >1;                                                                       
select  1 from db_root where unix_timestamp('1970-01-01 12:00:00')  >1; 

select  1 from db_root where unix_timestamp('00-01-01 12:00:00')  >1;                                                                       
select  1 from db_root where unix_timestamp('2000-01-01 12:00:00')  >1; 


