--+ server-message on

select 'It is called normally. ( t_boolean, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('boolean', a_param );
end;

call t_boolean('boolean' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_string, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param string := '123' ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('string', a_param );
end;

call t_boolean('string' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_short, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('short', a_param );
end;

call t_boolean('short' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_int, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('int', a_param );
end;

call t_boolean('int' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_bigint, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('bigint', a_param );
end;

call t_boolean('bigint' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_numeric(8,3), boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_boolean('numeric(8,3)' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_float, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('float', a_param );
end;

call t_boolean('float' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_double, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('double', a_param );
end;

call t_boolean('double' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_date, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('date', a_param );
end;

call t_boolean('date' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_time, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('time', a_param );
end;

call t_boolean('time' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_datetime, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('datetime', a_param );
end;

call t_boolean('datetime' ) ;
drop procedure t_boolean;



select 'An error occurs. ( t_timestamp, boolean )' ;
create or replace procedure t_boolean( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param boolean) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to boolean' ); 
        If param = True Then
            dbms_output.put_line('param value = TRUE' );
        Else
            dbms_output.put_line('param value = FALSE');
        end if;
    END;
begin
    t_local('timestamp', a_param );
end;

call t_boolean('timestamp' ) ;
drop procedure t_boolean;



--+ server-message off
