--+ holdcas on;
--find_in_set() function, empty string


select find_in_set('', '1,,3,4') result, if(find_in_set('', '1,,3,4') = 2, 'ok', 'nok');
select find_in_set('', ',1,3,4') result, if(find_in_set('', ',1,3,4') = 1, 'ok', 'nok');
select find_in_set('', '1,3,4,') result, if(find_in_set('', '1,3,4,') = 4, 'ok', 'nok');

set system parameters 'ansi_quotes=no';
select find_in_set("","a,b,c") result, if(find_in_set("","a,b,c") = 0, 'ok', 'nok');
select find_in_set("","a,b,c,") result, if(find_in_set("","a,b,c,") = 4, 'ok', 'nok');
select find_in_set("",",a,b,c") result, if(find_in_set("",",a,b,c") = 1, 'ok', 'nok');
commit;
--+ holdcas off;

set system parameters 'ansi_quotes=yes';
