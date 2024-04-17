--+ server-message on

-- If a function is used in the WHEN clause, check whether it is processed normally.

CREATE OR REPLACE PROCEDURE t()
AS
    tmp_str string;
BEGIN
    tmp_str := 'abc';
    FOR i IN 1 .. 9 LOOP
        tmp_str := tmp_str || i ;
        EXIT WHEN lengthb( tmp_str ) >5 ;
        put_line('tmp_str : ' || tmp_str);
    END LOOP;
    put_line('tmp_str : ' || tmp_str);
END;
call t();


CREATE OR REPLACE PROCEDURE t()
AS
    tmp_str string;
BEGIN
    tmp_str := 'abc';
    FOR i IN 1 .. 9 LOOP
        tmp_str := tmp_str || i ;
        EXIT WHEN decode(lengthb( tmp_str ),4,1, 5,2, 6,3, 7,4, 8,5, 9,6) >5 ;
        put_line('tmp_str : ' || tmp_str);
    END LOOP;
    put_line('tmp_str : ' || tmp_str);
END;
call t();


drop procedure t;

--+ server-message off
