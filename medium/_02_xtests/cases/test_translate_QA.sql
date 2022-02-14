autocommit off;
set names utf8;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');
SELECT TRANSLATE('X', NULL,NULL ) FROM tb; 
SELECT TRANSLATE('a', 'a', 'qwer') FROM tb; 	

SELECT TRANSLATE('2KRW229', 'KRW', '��ab') FROM tb;

SELECT TRANSLATE(NULL, NULL,NULL ) FROM tb; 


SELECT TRANSLATE('2KRW229', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', '9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM tb;
SELECT TRANSLATE('2KRW229', 'KRW', 'ab') FROM tb;

SELECT TRANSLATE('a', 'a', 'a') FROM tb; 
SELECT TRANSLATE('', '', '') FROM tb; 
select translate(NULL,NULL,NULL) from tb;
select translate(NULL,NULL,NULL) from tb;
drop table tb;
set names iso88591;
rollback;
