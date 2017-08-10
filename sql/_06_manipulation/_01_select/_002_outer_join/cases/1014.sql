--test LEFT OUTER JOIN,INNER JOIN using a select statement

create class page ( 
pwuh_id integer DEFAULT 0 NOT NULL, 
pwuh_mwvhapwnh integer DEFAULT 0 NOT NULL, 
pwuh_titsh character varying(255) DEFAULT '' NOT NULL 
); 


create class sjuuimu ( 
sju_tivhatwvp timestamp DEFAULT timestamp '12:00:00 AM 01/02/1970', 
sju_oahe integer DEFAULT 0 NOT NULL, 
sju_mwvhapwnh integer DEFAULT 0 NOT NULL, 
sju_titsh string DEFAULT '' NOT NULL, 
sju_id integer DEFAULT 0 NOT NULL 
) ;

create table vgoahe ( 
oahe_id integer DEFAULT 0 NOT NULL, 
oahe_mwvh character varying(255) DEFAULT '' NOT NULL 
) ;


insert into page (pwuh_id,pwuh_mwvhapwnh,pwuh_titsh) values(1,1, 'aaa') ;
insert into page (pwuh_id,pwuh_mwvhapwnh,pwuh_titsh) values(2,2, 'bbb') ;
insert into page (pwuh_id,pwuh_mwvhapwnh,pwuh_titsh) values(3,3, 'ccc') ;


insert into sjuuimu (sju_id, sju_mwvhapwnh,sju_oahe, sju_tivhatwvp) values (1,1,1, '2007-09-26 22:32:24'); 
insert into sjuuimu (sju_id, sju_mwvhapwnh,sju_oahe, sju_tivhatwvp) values (2,2,2, '2007-09-26 22:32:25'); 
insert into sjuuimu (sju_id, sju_mwvhapwnh,sju_oahe, sju_tivhatwvp) values (3,3,3, '2007-09-26 22:32:26'); 
insert into sjuuimu (sju_id, sju_mwvhapwnh,sju_oahe, sju_tivhatwvp) values (4,4,4, '2007-09-26 22:32:27'); 
insert into sjuuimu (sju_id, sju_mwvhapwnh,sju_oahe, sju_tivhatwvp) values (5,5,5, '2007-09-26 22:32:28'); 

insert into vgoahe (oahe_id,oahe_mwvh) values (1,'aaa') ;
insert into vgoahe (oahe_id,oahe_mwvh) values (2,'bbb') ;
insert into vgoahe (oahe_id,oahe_mwvh) values (3,'ccc') ;


SELECT * 
FROM sjuuimu LEFT OUTER JOIN page ON sju_mwvhapwnh=pwuh_mwvhapwnh 
AND sju_titsh=pwuh_titsh INNER JOIN vgoahe ON oahe_id=sju_oahe 
ORDER BY sju_tivhatwvp DESC for orderby_num() BETWEEN 1 AND 50 ;


drop class page, sjuuimu,vgoahe;
