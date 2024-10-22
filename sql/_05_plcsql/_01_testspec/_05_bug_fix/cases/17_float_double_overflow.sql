--+ server-message on
-- verified the CBRD-25555

create or replace procedure float_max() as
   v_FLOAT  float := 3.402823466E+39;
begin 
   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;

-- error: data overflow on data type FLOAT
call float_max();
drop procedure float_max;


create or replace procedure float_min() as
   v_FLOAT  float := -3.402823466E+39;
begin 
   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;

-- error: data overflow on data type FLOAT
call float_min();
drop procedure float_min;



create or replace procedure double_max() as
   v_Double  Double := 1.79769313486231570814527423731704357e+309;
begin 
   dbms_output.put_line('v_Double    ' || v_Double    );
end;

-- error: data overflow on data type DOUBLE
call double_max();
drop procedure double_max;


create or replace procedure double_min() as
   v_Double  Double := -1.79769313486231570814527423731704357e+309;
begin 
   dbms_output.put_line('v_Double    ' || v_Double    );
end;

-- error: data overflow on data type DOUBLE
call double_min();
drop procedure double_min;

--+ server-message off
