--+ holdcas on;
set names utf8;

drop table if exists t;
-- binary & euckr
select cast(_binary't' as string collate euckr_bin);
select charset(cast(_binary't' as string collate euckr_bin));
select collation(cast(_binary't' as string collate euckr_bin));
select coercibility(cast(_binary't' as string collate euckr_bin));

select cast(_euckr't' as string collate binary);
select charset(cast(_euckr't' as string collate binary));
select collation(cast(_euckr't' as string collate binary));
select coercibility(cast(_euckr't' as string collate binary));

-- binary & utf8
select cast(_binary'工' as string charset utf8);
select charset(cast(_binary'工' as string charset utf8));
select collation(cast(_binary'工' as string charset utf8));
select coercibility(cast(_binary'工' as string charset utf8));

select cast(_utf8'工' as string charset binary);
select charset(cast(_utf8'工' as string charset binary));
select collation(cast(_utf8'工' as string charset binary));
select coercibility(cast(_utf8'工' as string charset binary));

-- binary & iso88591
select cast(_iso88591't' as string collate binary);
select charset(cast(_iso88591't' as string collate binary));
select collation(cast(_iso88591't' as string collate binary));
select coercibility(cast(_iso88591't' as string collate binary));

select cast(_binary'工' as string collate iso88591_en_ci);
select charset(cast(_binary'工' as string collate iso88591_en_ci));
select collation(cast(_binary'工' as string collate iso88591_en_ci));
select coercibility(cast(_binary'工' as string collate iso88591_en_ci));
select coercibility(cast(_binary'工' as string collate iso88591_bin));

-- utf8 & iso88591
select cast(_iso88591't' as string collate utf8_bin);
select charset(cast(_iso88591't' as string collate utf8_en_cs));
select collation(cast(_iso88591't' as string collate utf8_en_ci));
select coercibility(cast(_iso88591't' as string collate utf8_ko_cs));
select coercibility(cast(_iso88591't' as string collate utf8_bin));

select cast(_utf8'工' as string collate iso88591_en_ci);
select charset(cast(_utf8'工' as string collate iso88591_en_ci));
select collation(cast(_utf8'工' as string collate iso88591_en_ci));
select coercibility(cast(_utf8'工' as string collate iso88591_en_ci));

set names utf8;
create table t(s string collate binary);
insert into t values('t');
select cast(s as string charset euckr) from t;
select charset(cast(s as string charset euckr)) from t;
select collation(cast(s as string charset euckr)) from t;
select coercibility(cast(s as string charset euckr)) from t;

drop t;
set names iso88591;

commit;
--+ holdcas off;
