--+ holdcas on;

set names utf8;
drop table if exists t;
create table t(id int, col string charset euckr, col1 string charset utf8);
insert into t values(1, '연산자와','연산자와');
insert into t values(2, '연산자와','연산자');

set names binary;
select * from t where col=any{col1};
select * from t where col=any{cast(col1 as string charset euckr), col};
select * from t where col=any{'연산자와'};
select * from t where col=any{_utf8'연산자와'};
select * from t where col=any{_euckr'연산자와'};

select * from t where col>all{col1};
select * from t where col=all{cast(col1 as string charset euckr), col};
select * from t where col=all{'연산자와'};
select * from t where col=all{_utf8'연산자와'};
select * from t where col=all{_euckr'연산자와'};

select * from t where col>some{col1};
select * from t where col=some{cast(col1 as string charset euckr), col};
select * from t where col=some{'연산자와'};
select * from t where col=some{_utf8'연산자와'};
select * from t where col=some{_euckr'연산자와'};

select * from t where col between _utf8'연산자' and _euckr'연산자와';
select * from t where col between '연산자' and '연산자와';
select * from t where col1 between '연산자' and '연산자와';
drop table t;

drop table if exists t1;
create table t1 (id int, col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1, '문자열', '문자열', '문자열', 'ÀÏ');
set names binary;
select * from t1 where id=1 and col_binary = ALL{cast ('문자열' as string collate binary), 'ÀÏ'};
select * from t1 where id=1 and col_binary = SOME{cast ('문자열' as string collate binary), 'ÀÏ'};
select * from t1 where id=1 and col_binary = ANY{cast ('문자열' as string collate binary), 'ÀÏ'};
drop table t1;

set names iso88591;
commit;

--+ holdcas off;