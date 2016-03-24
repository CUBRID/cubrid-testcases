--exceptional cases
--ELT(N,str1,str2,str3,...)


--pass 0 to N, NULL should be returned
select elt(0, 'a', 'b', 'c');
--pass negative value to N
select elt(-100, 'a', 'b', 'c');
--N > count of str
select elt(5, 'a', 'b', 'c');


--pass null
select elt(null, 'a', 'b', 'c');
select elt(2, 'a', null, 'c');
select elt(2, null, null);


--pass nothing
select elt(, 'a', 'b', 'c');
select elt(2, , 'b', 'c');
select elt(2, , , );


--pass out-of-range date/time data
select elt(2, date'2010-10-10', 22, time'12:66:32');
select elt(2, 'aaa', timestamp'13/12/1999 20:20:20', 'bbb');

--pass wrong format of date/time data
select elt(2, date'2000-10-10', datetime'bbb', datetime'ccc');
select elt(3, 111, date'abc', 'abc', time'efgefg');


--pass unmatched number of params
select elt();
select elt(3);
select elt(null);
