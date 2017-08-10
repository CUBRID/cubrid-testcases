--TEST: [I18N] Fail to insert values into SET column (CUBRID_CHARSET=ko_KR.euckr)


set names utf8;

create table t(s set(string)) collate utf8_en_ci;

insert into t values({_utf8'A',_utf8'A',_utf8'a'});
insert into t values({_euckr'A',_euckr'A',_euckr'a'});
insert into t values({_iso88591'A',_iso88591'a'});
insert into t values({'A', 'a'});

set names euckr;
insert into t values({_utf8'A',_utf8'A',_utf8'a'});
insert into t values({_euckr'A',_euckr'A',_euckr'a'});
insert into t values({_iso88591'A',_iso88591'a'});
insert into t values({'A', 'a'});

select * from t order by 1;


drop table t;

set names iso88591;
