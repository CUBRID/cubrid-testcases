--test
create serial Çç_Ğğ_İı
MINVALUE 1
MAXVALUE 3
NOCYCLE;
--test
SELECT Çç_Ğğ_İı.next_value,Çç_Ğğ_İı.next_value,Çç_Ğğ_İı.next_value FROM db_root;
--test
select * from db_serial WHERE name=lower('Çç_Ğğ_İı');
--test
drop serial Çç_Ğğ_İı;