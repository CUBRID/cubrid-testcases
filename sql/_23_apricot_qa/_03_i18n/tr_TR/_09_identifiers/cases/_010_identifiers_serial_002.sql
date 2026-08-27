--test
create serial Çç_Ğğ_İı
MINVALUE 1
MAXVALUE 3
NOCYCLE;
--test
SELECT Çç_Ğğ_İı.next_value,Çç_Ğğ_İı.next_value,Çç_Ğğ_İı.next_value FROM db_root;
--test
select CONCAT (LOWER (owner.name), '.', name) as unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name=lower('Çç_Ğğ_İı');
--test
drop serial Çç_Ğğ_İı;