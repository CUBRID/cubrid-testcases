--+ server-message on

-- Check if an error occurs for an unsupported BIT type.

create or replace procedure pp(i BIT) as 
begin
    dbms_output.put_line('i BIT : ' || i);
end;

create or replace procedure pp() as 
  var_bit BIT;
begin
    dbms_output.put_line('i BIT : ' || var_bit);
end;

create or replace function ff() return BIT as
  var_bit BIT := B'1';
begin
    return var_bit;
end;

--+ server-message off
