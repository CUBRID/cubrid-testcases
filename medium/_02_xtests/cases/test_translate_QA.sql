autocommit off;
set names utf8;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');
SELECT TRANSLATE('X', NULL,NULL ) FROM DUAL; 
SELECT TRANSLATE('a', 'a', 'qwer') FROM DUAL; 	

SELECT TRANSLATE('2KRW229', 'KRW', '��ab') FROM DUAL;

SELECT TRANSLATE(NULL, NULL,NULL ) FROM DUAL; 


SELECT TRANSLATE('2KRW229', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', '9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM DUAL  
SELECT TRANSLATE('2KRW229', 'KRW', 'ab') FROM DUAL  ;

SELECT TRANSLATE('a', 'a', 'a') FROM DUAL; 
SELECT TRANSLATE('', '', '') FROM DUAL; 
select translate(NULL,NULL,NULL) from dual;
select translate(NULL,NULL,NULL) from dual;
drop table dual;
set names iso88591;
rollback;
