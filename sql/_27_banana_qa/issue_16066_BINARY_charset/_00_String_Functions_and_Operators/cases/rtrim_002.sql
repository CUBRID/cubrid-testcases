---- bug CUBRIDSUS-17796

--+ holdcas on;
set names utf8;

drop table if exists t;
create table t ( 
	id int AUTO_INCREMENT , 
	col_binary varchar(20) charset binary, 
	col_utf8 varchar(20) charset utf8,
	col_euckr varchar(20) charset euckr,
	col_iso varchar(20) charset iso88591
);

insert into t values (null,'      空格        ' ,  '      空格        ','      空格        ' ,'      空格        ' );
insert into t values (null, '空空格格' ,  '空空格格','空空格格' ,'空空格格' );
insert into t values (null,'     011101     ' ,  '     011101     ','     011101     ' ,'     011101     ' );
insert into t values (null,'  스페이스 바' ,'  스페이스 바','  스페이스 바' ,'  스페이스 바' );
insert into t values (null, 'ÀÀÀÂÂ' ,'ÀÀÀÂÂ','ÀÀÀÂÂ' ,'ÀÀÀÂÂ' );

create index i on t(col_binary);

set names binary;

select * from t where col_binary='空空格格' order by 1;
select * from t where col_binary like '% %' order by 1;

select id, col_binary, col_utf8, HEX(col_euckr), col_iso from t order by 1;
---- bug CUBRIDSUS-17796
select id, rtrim(col_binary), rtrim(col_utf8), rtrim(col_euckr), rtrim(col_iso) from t where id in (1,3) order by 1; 
select id, rtrim(col_binary, NULL), rtrim(col_utf8, NULL), rtrim(col_euckr, NULL), rtrim(col_iso, NULL) from t order by 1;

select id, rtrim(col_binary, ' '), rtrim(col_utf8, ' '), rtrim(col_euckr, ' '), rtrim(col_iso, ' ') from t where id in (1,3) order by 1;
select id, rtrim(col_binary, '格'), rtrim(col_utf8, '格'), rtrim(col_euckr, '格'), rtrim(col_iso, '格') from t where id in (2) order by 1;
select id, rtrim(col_binary, '01     '), rtrim(col_utf8, '01     '), rtrim(col_euckr, '01     '), rtrim(col_iso, '01     ') from t where id in (3) order by 1;
select id, rtrim(col_binary, '바'), rtrim(col_utf8, '바'), rtrim(col_euckr, '바'),rtrim(col_euckr,cast( _utf8'바' as string charset euckr)), rtrim(col_iso, '바') from t where id in (4) order by 1;
select id, rtrim(col_binary, 'Â'), rtrim(col_utf8, 'Â'), HEX(rtrim(col_euckr, 'Â')), rtrim(col_iso, 'Â'),rtrim(col_iso,cast( _utf8'Â' as string charset iso88591) ) from t where id in (5) order by 1;

drop t;
set names iso88591;
--+ holdcas off;