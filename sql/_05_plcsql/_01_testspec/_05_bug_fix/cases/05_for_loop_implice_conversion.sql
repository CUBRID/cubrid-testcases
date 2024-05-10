--+ server-message on
-- Verified for CBRD-24967
-- Implicit type conversion to Integer of lower bound, upper bound and step values of FOR loops

CREATE OR REPLACE procedure poo AS 
	j int := 0;
BEGIN  
	FOR i IN '0' .. '10' by '5' LOOP  
		dbms_output.put_line('test for loop ' || i);
	END LOOP;
	
	while j <= '10' LOOP  
		dbms_output.put_line('test while loop ' || j);
		j := j + 5;
	END LOOP;
END;

call poo();

drop procedure poo;

--+ server-message off

