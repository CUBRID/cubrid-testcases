
select cast ( cast (_euckr'888' as char(20) collate euckr_bin)  as bigint);

select cast ( cast (_euckr'888' as char(20) collate euckr_bin)  as float);

select cast ( cast (_euckr'888' as char(20) collate euckr_bin)  as double);

select cast ( cast (_euckr'888' as char(20) collate euckr_bin)  as numeric);


select cast ( cast (_iso88591'123.345' as char(10) collate iso88591_bin)  as numeric(6,3));

select cast ( cast (_euckr'888' as char(20) collate euckr_bin)  as int);

select cast ( cast (_euckr'888' as char(20) collate euckr_bin)  as short);






select cast ( cast (_euckr'10/11/1999' as char(20) collate euckr_bin)  as date);

select cast ( cast (_euckr'10/11/1999' as char(20) collate euckr_bin)  as datetime);

select cast ( cast (_euckr'10:11:12' as char(20) collate euckr_bin)  as time);

select cast ( cast (_euckr'10:11:12' as char(20) collate euckr_bin)  as timestamp);



set system parameters 'intl_date_lang=ko_KR';
select to_date ( cast (_euckr'10/11/1999' as char(20) collate euckr_bin), 'DD/MM/YYYY', 'ko_KR');

select to_datetime ( cast (_euckr'10/11/1999' as char(20) collate euckr_bin), 'DD/MM/YYYY', 'ko_KR');

select to_time ( cast (_euckr'10:11:12' as char(20) collate euckr_bin), 'HH:MI:SS', 'ko_KR');

select to_timestamp ( cast (_euckr'01/01/2013 10:11:12' as char(20)));

select str_to_date ( cast (_euckr'10/11/1999' as char(20) collate euckr_bin) , '%d/%m/%y' );

set system parameters 'intl_date_lang=en_US';

select to_number (cast (_euckr'123' as char(20) collate euckr_bin) );
