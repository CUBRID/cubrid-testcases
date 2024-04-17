--+ server-message on

-- If a function is used in the WHEN clause, check whether it is processed normally.

CREATE OR REPLACE PROCEDURE t()
AS
    tmp_str string;
BEGIN
    tmp_str := 'abc';
    FOR i IN 1 .. 9 LOOP
        tmp_str := tmp_str || i ;
        EXIT WHEN lengthb( tmp_str ) ;
        put_line('tmp_str : ' || tmp_str);
    END LOOP;
    put_line('tmp_str : ' || tmp_str);
END;


CREATE OR REPLACE PROCEDURE t()
AS
    tmp_str string;
BEGIN
    tmp_str := 'abc';
    FOR i IN 1 .. 9 LOOP
        tmp_str := tmp_str || i ;
        EXIT WHEN decode(lengthb( tmp_str ),5,true, false ) ;
        put_line('tmp_str : ' || tmp_str);
    END LOOP;
    put_line('tmp_str : ' || tmp_str);
END;


--+ server-message off
