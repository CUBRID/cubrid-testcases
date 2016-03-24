--+ holdcas on;
-- 
select 0b10101;

select 0x10101;

set system parameters 'ansi_quotes=no';

select "1123";

select '1123';

set system parameters 'ansi_quotes=yes';

-- should fail
select "1123";

commit;
--+ holdcas off;
