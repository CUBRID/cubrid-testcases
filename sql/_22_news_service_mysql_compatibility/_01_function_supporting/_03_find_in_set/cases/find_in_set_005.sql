--pss set values to the 2nd param on server side


create table f05(
	col1 set(string),
	col2 multiset(string),
	col3 sequence(string)
);


insert into f05 values({'aaa','bbb','ccc','ddd','eee'}, {'aaa','bbb','ccc','ddd','eee'}, {'aaa','bbb','ccc','ddd','eee'});


--TEST: pass set value to the 2nd param
select find_in_set('aaa', col1) from f05; 
--TEST: pass multiset value to the 2nd param
select find_in_set('ccc', col1) from f05; 
--TEST: pass list value to the 2nd param
select find_in_set('eee', col1) from f05; 


drop table f05;
