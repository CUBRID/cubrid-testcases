--exceptional cases


--pass null
select space(null);

--pass 0 
select space(0);

--pass negative value
select space(-178);

--pass unmatched number of params
select space();
select space(2, 4);
