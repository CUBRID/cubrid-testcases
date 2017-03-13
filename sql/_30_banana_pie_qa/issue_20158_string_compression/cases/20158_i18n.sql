--+ holdcas on;

set names utf8;

drop table if exists t;

create table t (i1 int,col_binary varchar collate binary, col_euckr varchar collate euckr_bin, col_utf8 varchar collate utf8_bin, col_iso char(500) collate iso88591_bin);

insert into t values(1,'문자열문', '갱신되', '测试', 'ÀÏÀÏÀÏÀÏ');

insert into t values(2,repeat('문자열문',200), repeat('갱신되',200), repeat('测试',200), repeat('ÀÏÀÏÀÏÀÏ',200));

insert into t values(3,repeat(cast( _utf8'문자열문' as string charset euckr),200), repeat('갱신되',200), repeat('测试',200), repeat('ÀÏÀÏÀÏÀÏ',200));

insert into t values(4,repeat(cast( _utf8'ÀÏÀÏÀÏÀÏ' as string charset iso88591),200), repeat('문자열문',200), repeat('测试',200),repeat('동작은',200));

select * from t  order by 1,2,3,4;

select disk_size(col_binary),disk_size(col_euckr),disk_size(col_utf8),disk_size(col_iso) from t order by 1;


insert into t values(2,repeat('문자열문',200), repeat('갱신되',200), repeat('测试',200), repeat('ÀÏÀÏÀÏÀÏ',200));

insert into t values(2,repeat('문자열문',200), repeat('갱신되',200), repeat('测试',200), repeat('ÀÏÀÏÀÏÀÏ',200));

create index idx_t on t(i1,col_binary,col_euckr,col_iso);

select * from t where col_binary>'문' and col_iso>='동작은' and i1>=2;

select * from t t1,t t2 where t1.col_binary=t2.col_binary and t1.col_iso=t2.col_iso and t1.i1>=2 group by t2.col_euckr having t2.col_euckr>'갱' order by t1.col_utf8;

select col_binary into :a from t where i1=2 order by i1 desc limit 1;

select :a;

drop table t;

set names iso88591;

--+ holdcas off;
