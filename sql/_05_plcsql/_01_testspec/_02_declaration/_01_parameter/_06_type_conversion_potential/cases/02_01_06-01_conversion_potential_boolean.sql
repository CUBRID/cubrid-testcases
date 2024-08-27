--+ server-message on

select 'It is called normally. ( t_boolean, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param boolean := False ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
 call t_boolean('boolean' ) ;
 drop procedure t_boolean ;
select 'An error occurs. ( t_string, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param string := '123' ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_short, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_int, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param int := 78234 ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_bigint, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param bigint := 278234 ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_numeric(8,3), boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_float, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_double, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param double := 56789.1234 ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_date, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_time, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_datetime, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
select 'An error occurs. ( t_timestamp, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local_boolean(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean ' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local_boolean( 'boolean', a_param );
end;
--+ server-message off
