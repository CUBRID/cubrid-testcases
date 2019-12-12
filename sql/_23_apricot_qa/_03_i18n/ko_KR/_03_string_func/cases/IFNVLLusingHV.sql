--+ holdcas on;
set names utf8;
Create table t (col1 char(10) collate utf8_ko_cs_uca,col2 varchar(10) collate utf8_ko_cs_uca,col3 nchar(10) collate utf8_ko_cs_uca,col4 NCHAR VARYING(10) collate utf8_ko_cs_uca,col5 string collate utf8_ko_cs_uca);
insert into t values('가伽佳假價加可呵哥嘉','가伽佳假價加可呵哥嘉',N'가伽佳假價加可呵哥嘉',N'가伽佳假價加可呵哥嘉','가伽佳假價加可呵哥嘉');
insert into t values('각刻却各恪慤殼珏脚覺','각刻却各恪慤殼珏脚覺',N'각刻却各恪慤殼珏脚覺',N'각刻却各恪慤殼珏脚覺','각刻却各恪慤殼珏脚覺');
insert into t values('가刻却各恪慤殼珏脚覺','가刻却各恪慤殼珏脚覺',N'가刻却各恪慤殼珏脚覺',N'가刻却各恪慤殼珏脚覺','가刻却各恪慤殼珏脚覺');
insert into t values(null,null,null,null,null);

select col1, ifnull(col1,'각伽佳假價加可呵哥嘉') from t order by 2;
select col2, ifnull(col2,'각伽佳假價加可呵哥嘉') from t order by 2;
select col3, ifnull(col3,N'각伽佳假價加可呵哥嘉') from t order by 2;
select col4, ifnull(col4,N'각伽佳假價加可呵哥嘉') from t order by 2;
select col5, ifnull(col5,'각伽佳假價加可呵哥嘉') from t order by 2;

drop table t;
set names iso88591;
commit;
--+ holdcas off;