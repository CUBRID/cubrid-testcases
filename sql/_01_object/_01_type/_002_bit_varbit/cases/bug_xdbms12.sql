--[er] Test trim(),pad(), replace(), translate(), upper(), lower(), like with bit string
select trim(b'000100') from db_root;
select replace(b'000100') from db_root;
