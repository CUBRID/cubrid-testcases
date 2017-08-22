-- This testcase use modified Oracle samples. See below for the license:
-- Copyright (c) 2015 Oracle
-- Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.
--test outer join syntax
--it tests outer join syntax using (+) symbol

CREATE TABLE T1 ( 
  DEPARTMENT_ID    int    NOT NULL, 
  DEPARTMENT_NAME  VARCHAR(30),  
  MANAGER_ID       int,
  LOCATION_ID      int) ; 


CREATE TABLE T2 ( 
  EMPLOYEE_ID     int    NOT NULL, 
  FIRST_NAME      VARCHAR(20), 
  LAST_NAME       VARCHAR(25),
  EMAIL           VARCHAR(25),
  TEST_NUMBER    VARCHAR(20), 
  TEST_DATE       DATE,
  JOB_ID          VARCHAR(10),
  TEST_SAL          numeric(8,2), 
  COMMISSION_PCT  numeric(2,2), 
  MANAGER_ID      int, 
  DEPARTMENT_ID   int
  );

create view view_test as
select department_id, last_name, employee_id, job_id, TEST_SAL from T2 ;
insert into T1 values (10, 'Administration',200,1700);
insert into T1 values (20, 'Marketing',201,1800);
insert into T1 values (30, 'Purchasing',114,1700);
insert into T1 values (40, 'Human Resources',203,2400);                                       
insert into T1 values (50, 'Shipping',121,1500);                                              
insert into T1 values (60, 'IT',103,1400);                                                    
insert into T1 values (70, 'Public Relations',204,2700);                                      
insert into T1 values (80, 'Sales',145,2500);                                                 
insert into T1 values (90, 'Executive',100,1700);                                             
insert into T1 values (100,'Finance',108,1700);                                               
insert into T1 values (110,'Accounting',205,1700);                                            
insert into T1 values (120,'Treasury',null,1700);                                             
insert into T1 values (130,'Corporate Tax',null,1700);                                        
insert into T1 values (140,'Control And Credit',null,1700);                                   
insert into T1 values (150,'Shareholder Services',null,1700);                                 
insert into T1 values (160,'Benefits',null,1700);                                             
insert into T1 values (170,'Manufacturing',null,1700);                                        
insert into T1 values (180,'Construction',null,1700);                                         
insert into T1 values (190,'Contracting',null,1700);                                          
insert into T1 values (200,'Operations',null,1700);                                           
insert into T1 values (210,'IT Support',null,1700);                                           
insert into T1 values (220,'NOC',null,1700);                                                  
insert into T1 values (230,'IT Helpdesk',null,1700);                                          
insert into T1 values (240,'Government Sales',null,1700);                                     
insert into T1 values (250,'Retail Sales',null,1700);                                         
insert into T1 values (260,'Recruiting',null,1700);                                           
insert into T1 values (270,'Payroll',null,1700);                                              
                                              
insert into T2 values (100,'Steven','King','SKING','515.123.4567','06/17/1987','AD_PRES',24000,null,null,90);
insert into T2 values (101,'Neena','Kochhar','NKOCHHAR','515.123.4568','09/21/1989','AD_VP',17000,null,100,90);
insert into T2 values (102,'Lex','De Haan','LDEHAAN','515.123.4569','01/13/1993','AD_VP',17000,null,100,90);
insert into T2 values (103,'Alexander','Hunold','AHUNOLD','590.423.4567','01/03/1990','IT_PROG',9000,null,102,60);
insert into T2 values (104,'Bruce','Ernst','BERNST','590.423.4568','05/21/1991','IT_PROG',6000,null,103,60);
insert into T2 values (105,'David','Austin','DAUSTIN','590.423.4569','06/25/1997','IT_PROG',4800,null,103,60);
insert into T2 values (106,'Valli','Pataballa','VPATABAL','590.423.4560','02/05/1998','IT_PROG',4800,null,103,60);
insert into T2 values (107,'Diana','Lorentz','DLORENTZ','590.423.5567','02/07/1999','IT_PROG',4200,null,103,60);
insert into T2 values (108,'Nancy','Greenberg','NGREENBE','515.124.4569','08/17/1994','FI_MGR',12000,null,101,100);
insert into T2 values (109,'Daniel','Faviet','DFAVIET','515.124.4169','08/16/1994','FI_ACCOUNT',9000,null,108,100);
insert into T2 values (110,'John','Chen','JCHEN','515.124.4269','09/28/1997','FI_ACCOUNT',8200,null,108,100);
insert into T2 values (111,'Ismael','Sciarra','ISCIARRA','515.124.4369','09/30/1997','FI_ACCOUNT',7700,null,108,100);
insert into T2 values (112,'Jose Manuel','Urman','JMURMAN','515.124.4469','03/07/1998','FI_ACCOUNT',7800,null,108,100);
insert into T2 values (113,'Luis','Popp','LPOPP','515.124.4567','12/07/1999','FI_ACCOUNT',6900,null,108,100);
insert into T2 values (114,'Den','Raphaely','DRAPHEAL','515.127.4561','12/07/1994','PU_MAN',11000,null,100,30);
insert into T2 values (115,'Alexander','Khoo','AKHOO','515.127.4562','05/18/1995','PU_CLERK',3100,null,114,30);
insert into T2 values (116,'Shelli','Baida','SBAIDA','515.127.4563','12/24/1997','PU_CLERK',2900,null,114,30);
insert into T2 values (117,'Sigal','Tobias','STOBIAS','515.127.4564','07/24/1997','PU_CLERK',2800,null,114,30);
insert into T2 values (118,'Guy','Himuro','GHIMURO','515.127.4565','11/15/1998','PU_CLERK',2600,null,114,30);
insert into T2 values (119,'Karen','Colmenares','KCOLMENA','515.127.4566','08/10/1999','PU_CLERK',2500,null,114,30);
insert into T2 values (120,'Matthew','Weiss','MWEISS','650.123.1234','07/18/1996','ST_MAN',8000,null,100,50);
insert into T2 values (121,'Adam','Fripp','AFRIPP','650.123.2234','04/10/1997','ST_MAN',8200,null,100,50);
insert into T2 values (122,'Payam','Kaufling','PKAUFLIN','650.123.3234','05/01/1995','ST_MAN',7900,null,100,50);
insert into T2 values (123,'Shanta','Vollman','SVOLLMAN','650.123.4234','10/10/1997','ST_MAN',6500,null,100,50);
insert into T2 values (124,'Kevin','Mourgos','KMOURGOS','650.123.5234','11/16/1999','ST_MAN',5800,null,100,50);
insert into T2 values (125,'Julia','Nayer','JNAYER','650.124.1214','07/16/1997','ST_CLERK',3200,null,120,50);
insert into T2 values (126,'Irene','Mikkilineni','IMIKKILI','650.124.1224','09/28/1998','ST_CLERK',2700,null,120,50);
insert into T2 values (127,'James','Landry','JLANDRY','650.124.1334','01/14/1999','ST_CLERK',2400,null,120,50);
insert into T2 values (128,'Steven','Markle','SMARKLE','650.124.1434','03/08/2000','ST_CLERK',2200,null,120,50);
insert into T2 values (129,'Laura','Bissot','LBISSOT','650.124.5234','08/20/1997','ST_CLERK',3300,null,121,50);
insert into T2 values (130,'Mozhe','Atkinson','MATKINSO','650.124.6234','10/30/1997','ST_CLERK',2800,null,121,50);
insert into T2 values (131,'James','Marlow','JAMRLOW','650.124.7234','02/16/1997','ST_CLERK',2500,null,121,50);
insert into T2 values (132,'TJ','Olson','TJOLSON','650.124.8234','04/10/1999','ST_CLERK',2100,null,121,50);
insert into T2 values (133,'Jason','Mallin','JMALLIN','650.127.1934','06/14/1996','ST_CLERK',3300,null,122,50);
insert into T2 values (134,'Michael','Rogers','MROGERS','650.127.1834','08/26/1998','ST_CLERK',2900,null,122,50);
insert into T2 values (135,'Ki','Gee','KGEE','650.127.1734','12/12/1999','ST_CLERK',2400,null,122,50);
insert into T2 values (136,'Hazel','Philtanker','HPHILTAN','650.127.1634','02/06/2000','ST_CLERK',2200,null,122,50);
insert into T2 values (137,'Renske','Ladwig','RLADWIG','650.121.1234','07/14/1995','ST_CLERK',3600,null,123,50);
insert into T2 values (138,'Stephen','Stiles','SSTILES','650.121.2034','10/26/1997','ST_CLERK',3200,null,123,50);
insert into T2 values (139,'John','Seo','JSEO','650.121.2019','02/12/1998','ST_CLERK',2700,null,123,50);
insert into T2 values (140,'Joshua','Patel','JPATEL','650.121.1834','04/06/1998','ST_CLERK',2500,null,123,50);
insert into T2 values (141,'Trenna','Rajs','TRAJS','650.121.8009','10/17/1995','ST_CLERK',3500,null,124,50);
insert into T2 values (142,'Curtis','Davies','CDAVIES','650.121.2994','01/29/1997','ST_CLERK',3100,null,124,50);
insert into T2 values (143,'Randall','Matos','RMATOS','650.121.2874','03/15/1998','ST_CLERK',2600,null,124,50);
insert into T2 values (144,'Peter','Vargas','PVARGAS','650.121.2004','07/09/1998','ST_CLERK',2500,null,124,50);
insert into T2 values (145,'John','Russell','JRUSSEL','011.44.1344.429268','10/01/1996','SA_MAN',14000,.4,100,80);
insert into T2 values (146,'Karen','Partners','KPARTNER','011.44.1344.467268','01/05/1997','SA_MAN',13500,.3,100,80);
insert into T2 values (147,'Alberto','Errazuriz','AERRAZUR','011.44.1344.429278','03/10/1997','SA_MAN',12000,.3,100,80);
insert into T2 values (148,'Gerald','Cambrault','GCAMBRAU','011.44.1344.619268','10/15/1999','SA_MAN',11000,.3,100,80);
insert into T2 values (149,'Eleni','Zlotkey','EZLOTKEY','011.44.1344.429018','01/29/2000','SA_MAN',10500,.2,100,80);
insert into T2 values (150,'Peter','Tucker','PTUCKER','011.44.1344.129268','01/30/1997','SA_REP',10000,.3,145,80);
insert into T2 values (151,'David','Bernstein','DBERNSTE','011.44.1344.345268','03/24/1997','SA_REP',9500,.25,145,80);
insert into T2 values (152,'Peter','Hall','PHALL','011.44.1344.478968','08/20/1997','SA_REP',9000,.25,145,80);
insert into T2 values (153,'Christopher','Olsen','COLSEN','011.44.1344.498718','03/30/1998','SA_REP',8000,.2,145,80);
insert into T2 values (154,'Nanette','Cambrault','NCAMBRAU','011.44.1344.987668','12/09/1998','SA_REP',7500,.2,145,80);
insert into T2 values (155,'Oliver','Tuvault','OTUVAULT','011.44.1344.486508','11/23/1999','SA_REP',7000,.15,145,80);
insert into T2 values (156,'Janette','King','JKING','011.44.1345.429268','01/30/1996','SA_REP',10000,.35,146,80);
insert into T2 values (157,'Patrick','Sully','PSULLY','011.44.1345.929268','03/04/1996','SA_REP',9500,.35,146,80);
insert into T2 values (158,'Allan','McEwen','AMCEWEN','011.44.1345.829268','08/01/1996','SA_REP',9000,.35,146,80);
insert into T2 values (159,'Lindsey','Smith','LSMITH','011.44.1345.729268','03/10/1997','SA_REP',8000,.3,146,80);
insert into T2 values (160,'Louise','Doran','LDORAN','011.44.1345.629268','12/15/1997','SA_REP',7500,.3,146,80);
insert into T2 values (161,'Sarath','Sewall','SSEWALL','011.44.1345.529268','11/03/1998','SA_REP',7000,.25,146,80);
insert into T2 values (162,'Clara','Vishney','CVISHNEY','011.44.1346.129268','11/11/1997','SA_REP',10500,.25,147,80);
insert into T2 values (163,'Danielle','Greene','DGREENE','011.44.1346.229268','03/19/1999','SA_REP',9500,.15,147,80);
insert into T2 values (164,'Mattea','Marvins','MMARVINS','011.44.1346.329268','01/24/2000','SA_REP',7200,.1,147,80);
insert into T2 values (165,'David','Lee','DLEE','011.44.1346.529268','02/23/2000','SA_REP',6800,.1,147,80);
insert into T2 values (166,'Sundar','Ande','SANDE','011.44.1346.629268','03/24/2000','SA_REP',6400,.1,147,80);
insert into T2 values (167,'Amit','Banda','ABANDA','011.44.1346.729268','04/21/2000','SA_REP',6200,.1,147,80);
insert into T2 values (168,'Lisa','Ozer','LOZER','011.44.1343.929268','03/11/1997','SA_REP',11500,.25,148,80);
insert into T2 values (169,'Harrison','Bloom','HBLOOM','011.44.1343.829268','03/23/1998','SA_REP',10000,.2,148,80);
insert into T2 values (170,'Tayler','Fox','TFOX','011.44.1343.729268','01/24/1998','SA_REP',9600,.2,148,80);
insert into T2 values (171,'William','Smith','WSMITH','011.44.1343.629268','02/23/1999','SA_REP',7400,.15,148,80);
insert into T2 values (172,'Elizabeth','Bates','EBATES','011.44.1343.529268','03/24/1999','SA_REP',7300,.15,148,80);
insert into T2 values (173,'Sundita','Kumar','SKUMAR','011.44.1343.329268','04/21/2000','SA_REP',6100,.1,148,80);
insert into T2 values (174,'Ellen','Abel','EABEL','011.44.1644.429267','05/11/1996','SA_REP',11000,.3,149,80);
insert into T2 values (175,'Alyssa','Hutton','AHUTTON','011.44.1644.429266','03/19/1997','SA_REP',8800,.25,149,80);
insert into T2 values (176,'Jonathon','Taylor','JTAYLOR','011.44.1644.429265','03/24/1998','SA_REP',8600,.2,149,80);
insert into T2 values (177,'Jack','Livingston','JLIVINGS','011.44.1644.429264','04/23/1998','SA_REP',8400,.2,149,80);
insert into T2 values (178,'Kimberely','Grant','KGRANT','011.44.1644.429263','05/24/1999','SA_REP',7000,.15,149,null);
insert into T2 values (179,'Charles','Johnson','CJOHNSON','011.44.1644.429262','01/04/2000','SA_REP',6200,.1,149,80);
insert into T2 values (180,'Winston','Taylor','WTAYLOR','650.507.9876','01/24/1998','SH_CLERK',3200,null,120,50);
insert into T2 values (181,'Jean','Fleaur','JFLEAUR','650.507.9877','02/23/1998','SH_CLERK',3100,null,120,50);
insert into T2 values (182,'Martha','Sullivan','MSULLIVA','650.507.9878','06/21/1999','SH_CLERK',2500,null,120,50);
insert into T2 values (183,'Girard','Geoni','GGEONI','650.507.9879','02/03/2000','SH_CLERK',2800,null,120,50);
insert into T2 values (184,'Nandita','Sarchand','NSARCHAN','650.509.1876','01/27/1996','SH_CLERK',4200,null,121,50);
insert into T2 values (185,'Alexis','Bull','ABULL','650.509.2876','02/20/1997','SH_CLERK',4100,null,121,50);
insert into T2 values (186,'Julia','Dellinger','JDELLING','650.509.3876','06/24/1998','SH_CLERK',3400,null,121,50);
insert into T2 values (187,'Anthony','Cabrio','ACABRIO','650.509.4876','02/07/1999','SH_CLERK',3000,null,121,50);
insert into T2 values (188,'Kelly','Chung','KCHUNG','650.505.1876','06/14/1997','SH_CLERK',3800,null,122,50);
insert into T2 values (189,'Jennifer','Dilly','JDILLY','650.505.2876','08/13/1997','SH_CLERK',3600,null,122,50);
insert into T2 values (190,'Timothy','Gates','TGATES','650.505.3876','07/11/1998','SH_CLERK',2900,null,122,50);
insert into T2 values (191,'Randall','Perkins','RPERKINS','650.505.4876','12/19/1999','SH_CLERK',2500,null,122,50);
insert into T2 values (192,'Sarah','Bell','SBELL','650.501.1876','02/04/1996','SH_CLERK',4000,null,123,50);
insert into T2 values (193,'Britney','Everett','BEVERETT','650.501.2876','03/03/1997','SH_CLERK',3900,null,123,50);
insert into T2 values (194,'Samuel','McCain','SMCCAIN','650.501.3876','07/01/1998','SH_CLERK',3200,null,123,50);
insert into T2 values (195,'Vance','Jones','VJONES','650.501.4876','03/17/1999','SH_CLERK',2800,null,123,50);
insert into T2 values (196,'Alana','Walsh','AWALSH','650.507.9811','04/24/1998','SH_CLERK',3100,null,124,50);
insert into T2 values (197,'Kevin','Feeney','KFEENEY','650.507.9822','05/23/1998','SH_CLERK',3000,null,124,50);
insert into T2 values (198,'Donald','OConnell','DOCONNEL','650.507.9833','06/21/1999','SH_CLERK',2600,null,124,50);
insert into T2 values (199,'Douglas','Grant','DGRANT','650.507.9844','01/13/2000','SH_CLERK',2600,null,124,50);
insert into T2 values (200,'Jennifer','Whalen','JWHALEN','515.123.4444','09/17/1987','AD_ASST',4400,null,101,10);
insert into T2 values (201,'Michael','Hartstein','MHARTSTE','515.123.5555','02/17/1996','MK_MAN',13000,null,100,20);
insert into T2 values (202,'Pat','Fay','PFAY','603.123.6666','08/17/1997','MK_REP',6000,null,201,20);
insert into T2 values (203,'Susan','Mavris','SMAVRIS','515.123.7777','06/07/1994','HR_REP',6500,null,101,40);
insert into T2 values (204,'Hermann','Baer','HBAER','515.123.8888','06/07/1994','PR_REP',10000,null,101,70);
insert into T2 values (205,'Shelley','Higgins','SHIGGINS','515.123.8080','06/07/1994','AC_MGR',12000,null,101,110);
insert into T2 values (206,'William','Gietz','WGIETZ','515.123.8181','06/07/1994','AC_ACCOUNT',8300,null,205,110);

select ve.last_name, ve.department_id, d.department_name 
from T1 d left outer join view_test ve 
on d.department_id = ve.department_id 
order by d.department_name, 3, 1;

select ve.last_name, ve.department_id, d.department_name 
from T1 d , view_test ve 
where d.department_id = ve.department_id (+)
order by d.department_name, 3, 1;

select ve.last_name, ve.department_id, d.department_name 
from T1 d right outer join view_test ve
on d.department_id = ve.department_id 
order by d.department_name, 3, 1;

select ve.last_name, ve.department_id, d.department_name 
from T1 d , view_test ve 
where d.department_id(+) = ve.department_id 
order by d.department_name, 3, 1;





drop table T2;
drop table T1;
drop view view_test;
