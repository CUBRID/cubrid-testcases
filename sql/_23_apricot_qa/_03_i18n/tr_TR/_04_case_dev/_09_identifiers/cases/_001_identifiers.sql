-- table name
create table t_Çç_Ğğ_İı_Öö_Şş_Üü(s1 char(200));

-- column
alter table t_Çç_Ğğ_İı_Öö_Şş_Üü add column i_Çç_Ğğ_İı_Öö_Şş_Üü int;

-- trigger
create trigger tr_Çç_Ğğ_İı_Öö_Şş_Üü before update on t_Çç_Ğğ_İı_Öö_Şş_Üü execute update t_Çç_Ğğ_İı_Öö_Şş_Üü set i_Çç_Ğğ_İı_Öö_Şş_Üü = 0;

-- constraint
alter table t_Çç_Ğğ_İı_Öö_Şş_Üü add constraint i_Çç_Ğğ_İı_Öö_Şş_Üü_i_u unique index (i_Çç_Ğğ_İı_Öö_Şş_Üü);

desc t_Çç_Ğğ_İı_Öö_Şş_Üü;
show index in t_Çç_Ğğ_İı_Öö_Şş_Üü;

drop trigger tr_Çç_Ğğ_İı_Öö_Şş_Üü;

alter table t_Çç_Ğğ_İı_Öö_Şş_Üü drop constraint i_Çç_Ğğ_İı_Öö_Şş_Üü_i_u;

alter table t_Çç_Ğğ_İı_Öö_Şş_Üü drop column i_Çç_Ğğ_İı_Öö_Şş_Üü;

drop table t_Çç_Ğğ_İı_Öö_Şş_Üü;


-- names starting with TR letters
create table Çer (Şut int);

alter table Çer add column Ünu int;

create trigger ğer before update on Çer execute update Çer set Şut = 0;

alter table Çer add constraint İndex unique index (Şut);
alter table Çer add constraint ındex unique index (Ünu);

desc Çer;
show index in Çer;

drop trigger ğer;

alter table Çer drop constraint İndex;
alter table Çer drop constraint ındex;

alter table Çer drop column Şut;
alter table Çer drop column Ünu;
drop table Çer;

