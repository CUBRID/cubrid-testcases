show timezones;
show timezones like 'Africa%';
show timezones like 'Asia%';
show timezones like 'Brazil%';
show timezones like 'Europe%';
show timezones like 'Indian%';
show timezones like 'America%';
show timezones like 'A%';
show timezones like 'B%';
show timezones like 'C%';
show timezones like 'E%';


show timezones like 'F%';
show timezones like '%/F%'; 

show timezones like 'G%';
show timezones like 'H%';
show timezones like 'I%';
show timezones not like 'P%';


show timezones where timezone_region in ('Europe/Berlin','Asia/Shanghai');

show full timezones where timezone_region in ('Australia/Darwin','Asia/Shanghai');


show timezones like 'A%' where timezone_region='Europe/Berlin';
show timezones like 'E%' where timezone_region='Europe/Berlin';
show timezones like 'A%' where timezone_region!='Europe/Berlin' and timezone_region like 'Asia%' order by 1 limit 10;

show timezones where timezone_region='Europe/Berlin';
show timezones where timezone_region!='Europe/Berlin' and timezone_region like 'Asia%' order by 1 limit 10;
show timezones where timezone_region!='Europe/Berlin' and timezone_region like 'Asia%' ;

show timezones where timezone_region!='Europe/Berlin' and timezone_region like 'Asia/A%';
show full timezones where timezone_region!='Europe/Berlin' and timezone_region like 'Asia/A%' and timezone_region!='Asia/Amman';
show timezones where timezone_region!='Europe/Berlin' and timezone_region like 'Asia/B%';
show full timezones where timezone_region!='Europe/Berlin' and timezone_region like 'Asia/B%' and timezone_region not in('Asia/Baku', 'Asia/Beirut');
show full timezones where timezone_region!='Asia/Baku' and timezone_region!='Asia/Beirut' and timezone_region like 'Asia/B%';

show timezones where timezone_region='Africa/Juba';
show full timezones where timezone_region='Africa/Juba';

show timezones where timezone_region=(select 'Asia'||'/'+'Beijing' from db_root );
show timezones where timezone_region=(select 'Asia'||'/'+'Shanghai' from db_root );
show timezones where timezone_region=(select 'Asia'||'/'+'Chongqing' from db_root );
show full timezones where timezone_region=(select 'Asia'||'/'+'Chongqing' from db_root );
show full timezones where timezone_region=(select 'Asia'||'/'+'Shanghai' from db_root );
show full timezones where timezone_region=(select 'Asia'||'/'+'Beijing' from db_root );
show full timezones where timezone_region in (select 'Asia'||'/'+'Shanghai' from db_root );


show timezones where timezone_region=(select concat('Asia','/','Beijing'));
show timezones where left(timezone_region,4)='Asia' order by 1;
show timezones where left(timezone_region,4)='Asia' ;
show timezones where left(timezone_region,13)='Asia/Shanghai';
show timezones where left(timezone_region,4)!='Asia' ;

show timezones where lower(timezone_region) like 'asia%' order by 1 limit 20;
show timezones where substr(timezone_region,1,6)='Europe' order by 1 limit 10;
show timezones where substr(timezone_region,-5,5)='Seoul' order by 1 limit 10;
show timezones where strcmp(timezone_region,'Asia/Seoul')=0 order by 1 ;
show timezones where strcmp(timezone_region,'Asia/Seoul')=1 group by substr(timezone_region,1,locate('/',timezone_region)-1) order by 1;


  
