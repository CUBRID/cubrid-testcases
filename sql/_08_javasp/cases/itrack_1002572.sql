autocommit off;

CREATE TABLE hvpsjzhha (
   atjeh_id INT NOT NULL
)
PARTITION BY RANGE (atjeh_id + 100) (
PARTITION p0 VALUES LESS THAN (105),
PARTITION p1 VALUES LESS THAN (200),
PARTITION p3 VALUES LESS THAN MAXVALUE
);

insert into hvpsjzhha values(1);
insert into hvpsjzhha values(105);
insert into hvpsjzhha values(106);

select count(*) from hvpsjzhha;
select * from hvpsjzhha order by 1;
$integer,$105;
select * from hvpsjzhha where atjeh_id = ? order by 1;
$integer,$1000005;
select * from hvpsjzhha where atjeh_id < ? order by 1;

create class x ( id int);
insert into  x values(10);
select * from x order by 1;

drop hvpsjzhha;
drop x;


create PROCEDURE imahetEjjvAbjt(oaheMid varchar , abjt_njdh VARCHAR ,abjt_id varchar , p_njdh varchar ,  p_id varchar ,  aolqhnt varchar, vhvj varchar , ip varchar ,  a_ithv varchar,  vzvau varchar , fvau1 varchar,fmsg2 varchar ,  fvau3 varchar ,  fvau4 varchar ,  fvau5 varchar) as LANGUAGE JAVA NAME 'Itrack.i1002572(java.lang.String, java.lang.String, java.lang.String,java.lang.String, java.lang.String, java.lang.String, java.lang.String,java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)';

call imahetEjjvAbjt('25197868','25197868','HINEKOGYC','','','123','123','123.456.789.012', 'HBGBA001004_0_0_0_0_0,avatar_69_170_1_160_120,HPE00001040_5_371_2_49_143,HPE00001042_0_364_3_64_142,HPE00001041_11_12_4_63_142,HPE00001043_100_277_5_58_139,HPE00001044_58_102_6_64_142,HAN00001002_182_376_7_36_41,HAN00002017_134_0_8_113_106,HAN00001001_175_332_9_37_52,HPE00001019_2_159_10_108_127,HPE00001035_14_74_11_52_140,HPE00001039_93_120_12_96_141,msg25197868_100_100_13_119_57,', '1231','','','','','');






rollback;

autocommit on;

