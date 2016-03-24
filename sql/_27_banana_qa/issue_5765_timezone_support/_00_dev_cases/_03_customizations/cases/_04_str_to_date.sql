/* test datetimetz */
select str_to_date('01,5,2013, Asia/Seoul','%d,%m,%Y, %TZR') from db_root;
select str_to_date('01,5,2013, Europe/Vienna, CEST','%d,%m,%Y, %TZR,%TZD') from db_root;
select str_to_date('01,5,2013, Europe/Vienna, CET','%d,%m,%Y, %TZR,%TZD') from db_root;
select str_to_date('01,5,2013, Europe/Viennaa, CEST','%d,%m,%Y, %TZR,%TZD') from db_root;
select str_to_date('01,5,Europe/Paris, 2013, CEST','%d,%m,%TZR,%Y, %TZD') from db_root;
select str_to_date('01,5,CEST, 2013, Europe/Paris','%d,%m,%TZD,%Y, %TZR') from db_root;
select str_to_date('01,5,CEST, Europe/Paris, 2013','%d,%m,%TZD, %TZR, %Y') from db_root;
select str_to_date('01,5,CEST, 2013, Europe/Brussels 21','%d,%m,%TZD,%Y, %TZR %TZH') from db_root;
select str_to_date('01,5,CEST, 2013, Europe/Zurich','%d,%m,%TZD,%Y, %TZR %TZH') from db_root;
select str_to_date('01,5,CEST, 2013, Europe/Zurich 22','%d,%m,%TZD,%Y, %TZR %TZM') from db_root;
select str_to_date('01,5,2013, CEST','%d,%m,%Y, %TZD') from db_root;
select str_to_date('01,5,2013, 22','%d,%m,%Y, %TZH') from db_root;
select str_to_date('01,5,2013, 22','%d,%m,%Y, %TZM') from db_root;
select str_to_date('01,5,2013, 22, -24','%d,%m,%Y, %TZM, %TZH') from db_root;
select str_to_date('01,5,2013, 22, -23','%d,%m,%Y, %TZM, %TZH') from db_root;
select str_to_date('01,5,2013, +22, -23','%d,%m,%Y, %TZM, %TZH') from db_root;
select str_to_date('01,5,2013, -22, -23','%d,%m,%Y, %TZM, %TZH') from db_root;
select str_to_date('01, 22 ,5, -23 ,2013','%d, %TZM, %m, %TZH, %Y') from db_root;

/* test timetz */
--BUG: CUBRIDSUS-17061, resolved
select str_to_date('09:30:17 Asia/Seoul','%h:%i:%s %TZR') from db_root;
select str_to_date('09:30:17, Asia/Seoul','%h:%i:%s, %TZR') from db_root;
select str_to_date('09,30,17, Europe/Minsk, EEST','%h,%i,%s, %TZR,%TZD') from db_root;
select str_to_date('09,30,17, Europe/Minsk, FET','%h,%i,%s, %TZR,%TZD') from db_root;
select str_to_date('07,07,07, Europe/Viennaa, CEST','%h,%i,%s, %TZR,%TZD') from db_root;
select str_to_date('08,23,America/Maceio, 15, BRT','%h,%i,%TZR,%s, %TZD') from db_root;
select str_to_date('08,23,BRT, 15, America/Maceio','%h,%i,%TZD,%s, %TZR') from db_root;
select str_to_date('04,12,BRT, America/Maceio, 12','%h,%i,%TZD, %TZR, %s') from db_root;
select str_to_date('01,5,DDUT, 2013, Antarctica/DumontDUrville 10','%h,%i,%TZD,%s, %TZR %TZH') from db_root;
select str_to_date('01,5,CST, 9, Asia/Macau','%h,%i,%TZD,%s, %TZR %TZH') from db_root;
select str_to_date('01,5,CDT, 10, Asia/Macau 22','%h,%i,%TZD,%s, %TZR %TZM') from db_root;
select str_to_date('01,5,10, CEST','%h,%i,%s, %TZD') from db_root;
select str_to_date('01,5,5, 22','%h,%i,%s, %TZH') from db_root;
select str_to_date('02,15,20, 22','%h,%i,%s, %TZM') from db_root;
select str_to_date('01,5,1, 22, -24','%h,%i,%s, %TZM, %TZH') from db_root;
select str_to_date('01,5,1, 22, -23','%h,%i,%s, %TZM, %TZH') from db_root;
select str_to_date('01,5,1, +22, -23','%h,%i,%s, %TZM, %TZH') from db_root;
select str_to_date('01,5,1, -22, -23','%h,%i,%s, %TZM, %TZH') from db_root;
select str_to_date('10, 22 ,5, -23 ,20','%h, %TZM, %i, %TZH, %s') from db_root;



select str_to_date('09:30:17 20140303EETEurope/Bucharest','%h:%i:%s %Y%d%m%TZD3%TZR') from db_root;
select str_to_date('09:30:17 20140307EESTEurope/Bucharest','%h:%i:%s %Y%d%m%TZD4%TZR') from db_root;
select str_to_date('09:30:17 20140307EESTEurope/Bucharest','%h:%i:%s %Y%d%m%TZD%TZR') from db_root;
