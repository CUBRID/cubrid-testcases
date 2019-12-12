-- create class,insert data into class,retrieve class using where clause

create class n_fix (  
wn_wnnt_omit char(4) );

insert into n_fix values('A000');
insert into n_fix values('A090');
insert into n_fix values('A610');
insert into n_fix values('A620');
insert into n_fix values('A630');
insert into n_fix values('A640');
insert into n_fix values('A650');
insert into n_fix values('A660');
insert into n_fix values('A670');
insert into n_fix values('A680');
insert into n_fix values('A690');
insert into n_fix values('A600');
insert into n_fix values('A600');
insert into n_fix values('A600');
insert into n_fix values('A700');


select distinct wn_wnnt_omit                                           
FROM  n_fix                                                            
WHERE                                                                  
 wn_wnnt_omit BETWEEN 'A000'  AND  'A999'                             
 AND  (wn_wnnt_omit       > 'A600' or wn_wnnt_omit       = 'A090');
select distinct wn_wnnt_omit                                           
FROM  n_fix                                                            
WHERE                                                                  
 (wn_wnnt_omit       > 'A600' or wn_wnnt_omit       = 'A090')  
 AND  wn_wnnt_omit BETWEEN 'A000'  AND  'A999' ;





drop class n_fix;
