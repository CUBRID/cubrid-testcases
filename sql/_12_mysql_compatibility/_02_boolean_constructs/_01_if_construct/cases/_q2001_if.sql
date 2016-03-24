SELECT IF(1>2,true,false) from db_root;
select if(sign(5-2)>0,111,222) from db_root;
select if(sign(2-5)>0,111,222) from db_root;
SELECT LPAD('123', if(length('123')<5,5,length('123')), 'X') FROM db_root;

select IF(1>2,2,IF(1>2,2,IF(1>2,2,3))) from db_root;
select IF(1<2,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) from db_root;

select IF(9223372036854775807<9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) from db_root;
select IF(-9223372036854775807<-9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) from db_root;
select IF(-9223372036854775808<-9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) from db_root;
select IF(-9223372036854775809<-9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) from db_root;

select IF(-9223372036854775809<-9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) & 4 from db_root;
select IF(-9223372036854775809<-9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) | 4 from db_root;
select IF(-9223372036854775809<-9223372036854775808,IF(1>2,2,5),IF(1>2,2,IF(1>2,2,3))) ^ 4 from db_root;
