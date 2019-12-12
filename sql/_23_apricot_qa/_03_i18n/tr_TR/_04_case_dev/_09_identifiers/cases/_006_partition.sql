
create table t_Çç_Ğğ_İı_Öö_Şş_Üü( i_Çç_Ğğ_İı_Öö_Şş_Üü int) partition by range (i_çç_ğğ_İı_öö_şş_üü) (partition p0 VALUES LESS THAN (2),partition p1 VALUES LESS THAN (20));

insert into t_Çç_Ğğ_İı_Öö_Şş_Üü values (1), (3), (5);

select * from T_ÇÇ_ĞĞ_İı_ÖÖ_ŞŞ_ÜÜ__P__P0 order by 1;
select * from t_çç_ğğ_İı_öö_şş_üü__p__p1 order by 1;

desc t_çç_ğğ_İı_öö_şş_üü;

drop table T_ÇÇ_ĞĞ_İı_ÖÖ_ŞŞ_ÜÜ;
