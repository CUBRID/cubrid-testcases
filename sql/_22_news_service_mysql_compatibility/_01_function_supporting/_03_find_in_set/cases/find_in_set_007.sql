--+ holdcas on;
--TEST: exceptional cases


--TEST: str is not in strlist
select find_in_set('hello', 'a,b,c,hell,hi,1,2,3') result, if(find_in_set('hello', 'a,b,c,hell,hi,1,2,3') = 0, 'ok', 'nok');
select find_in_set(1, '2,3,4,5,11,111,43') result, if(find_in_set(1, '2,3,4,5,11,111,43') = 0, 'ok', 'nok');


--TEST: special marks in str
select find_in_set('-', '-,/,a,b,\,c') result, if(find_in_set('-', '-,/,a,b,\,c') = 1, 'ok', 'nok');
select find_in_set('12:12:12', '1,12,12:12:12,14:15') result, if(find_in_set('12:12:12', '1,12,12:12:12,14:15') = 3, 'ok', 'nok');
select find_in_set(date'10/10/2010', '10/10/2010,13,45/67,1,2') result, if(find_in_set(date'10/10/2010', '10/10/2010,13,45/67,1,2') = 1, 'ok', 'nok');
select find_in_set('1-1', '23-23,5-5,6-6,1-1,0-0') result, if(find_in_set('1-1', '23-23,5-5,6-6,1-1,0-0') = 4, 'ok', 'nok');
select find_in_set(',:','[,:,\,<,&') result, if(find_in_set(',:','[,:,\,<,&') = 0, 'ok', 'nok');
select find_in_set('a-b-c', 'a-b,a-b-c-,a-b-c,a-b-c-d') result, if(find_in_set('a-b-c', 'a-b,a-b-c-,a-b-c,a-b-c-d') = 3, 'ok', 'nok');
--TEST: comma contained in the 1st param
select find_in_set('a,b', 'a,b,c,a,b,d') result, if(find_in_set('a,b', 'a,b,c,a,b,d') = 0, 'ok', 'nok');
select find_in_set(',', 'b,c,a,\,,d') result, if(find_in_set(',', 'b,c,a,\,,d') = 0, 'ok', 'nok');


--TEST: 1st param is empty string
select find_in_set('', '1,3,2,5') result, if(find_in_set('', '1,3,2,5') = 0, 'ok', 'nok');


--TEST: 2nd param is empty string
select find_in_set('a', '') result, if(find_in_set('a', '') = 0, 'ok', 'nok');
select find_in_set('', '1,'',2') result, if(find_in_set('', '1,'',2') = 0, 'ok', 'nok');
select find_in_set('a', 'a,b,'',c') result, if(find_in_set('a', 'a,b,'',c') = 1, 'ok', 'nok');
--TEST: both params are empty strings
select find_in_set('', '') result, if(find_in_set('', '') = 0, 'ok', 'nok');


--TEST: duplicated values in the strlist
select find_in_set('a', 'c,d,e,a,b,e,f,a,g') result, if(find_in_set('a', 'c,d,e,a,b,e,f,a,g') = 4, 'ok', 'nok');
select find_in_set('hello', 'a,b,c,hello,HELLO,hello') result, if(find_in_set('hello', 'a,b,c,hello,HELLO,hello') = 4, 'ok', 'nok');
select find_in_set('ddd', 'ddd,ddd,ddd,ddd') result, if(find_in_set('ddd', 'ddd,ddd,ddd,ddd') = 1, 'ok', 'nok');


--TEST: pass null to the 1st param
select find_in_set(null, 'a,b,c') result, if(find_in_set(null, 'a,b,c') is null, 'ok', 'nok');
select find_in_set(null, 'a,b,null,c') result, if(find_in_set(null, 'a,b,null,c') is null, 'ok', 'nok');
--TEST: pass null to the 2nd param
select find_in_set('a-b-c', null) result, if(find_in_set('a-b-c', null) is null, 'ok', 'nok');
select find_in_set('a-b-c', 'a,null,a-b-c,b,c,d') result, if(find_in_set('a-b-c', 'a,null,a-b-c,b,c,d') = 3, 'ok', 'nok');
--TEST: pass null to both params
select find_in_set(null, null) result, if(find_in_set(null, null) is null, 'ok', 'nok');


--TEST: pass space to the params
select find_in_set('  ', 'a,b,  ,c') result, if(find_in_set('  ', 'a,b,  ,c') = 3, 'ok', 'nok');
set system parameters 'ansi_quotes=no';
select find_in_set(' ', "a,b,' ',c,d") result, if(find_in_set(' ', "a,b,' ',c,d") = 0, 'ok', 'nok');
set system parameters 'ansi_quotes=yes';
select find_in_set(' ', ' ') result, if(find_in_set(' ', ' ') = 1, 'ok', 'nok');


--pass unmatched number of params
select find_in_set() result, if(  );
select find_in_set(null) result, if(  );
select find_in_set('a-b-c') result, if(  );
select find_in_set('a-b-c', 'a-b,a-b-c-,a-b-c,a-b-c-d', ) result, if(  );
select find_in_set('a', 'a,b,c', 2) result, if(  );
select find_in_set(?, ?) result, if(  );


commit;
--+ holdcas off;
