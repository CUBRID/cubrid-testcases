--+ server-message on

-- This test case verifies the following issue: CBRD-25982

-- Status              ISOPEN   FOUND     NOTFOUND   ROWCOUNT  
-- Before OPEN         FALSE    Exception Exception  Exception  
-- After OPEN, before FETCH  TRUE     NULL      NULL       0  
-- After FETCH (1st and 2nd valid fetch)  TRUE     TRUE      FALSE      1, 2  
-- After FETCH (no more data)            TRUE     FALSE     TRUE       2  
-- After CLOSE          FALSE    Exception Exception  Exception  

drop table if exists athlete_t;
CREATE TABLE athlete_t (
  code INTEGER NOT NULL,
  name VARCHAR(40) NOT NULL,
  PRIMARY KEY (code)
);

INSERT INTO athlete_t (code, name) VALUES
(101, 'Michael Phelps'),
(102, 'Usain Bolt'),
(103, 'Simone Biles'),
(104, 'Carl Lewis'),
(105, 'Serena Williams');

CREATE OR REPLACE PROCEDURE cursor_status_nation_athletes()
IS 
    code INT;
    name VARCHAR(40);
    step VARCHAR(40);
    CURSOR c IS SELECT code, name FROM athlete_t ORDER BY 1 LIMIT 2;
BEGIN
    step := 'Before OPEN - ISOPEN : ';
    BEGIN
        IF c%ISOPEN IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%ISOPEN 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'Before OPEN - FOUND : ';
    BEGIN
        IF c%FOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%FOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'Before OPEN - NOTFOUND : ';
    BEGIN
        IF c%NOTFOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%NOTFOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'Before OPEN - ROWCOUNT : ';
    BEGIN
        IF c%ROWCOUNT IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            DBMS_OUTPUT.PUT_LINE(step || c%ROWCOUNT);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    OPEN c;

    step := 'After OPEN, Before FETCH - ISOPEN : ';
    BEGIN
        IF c%ISOPEN IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%ISOPEN 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'After OPEN, Before FETCH - FOUND : ';
    BEGIN
        IF c%FOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%FOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'After OPEN, Before FETCH - NOTFOUND : ';
    BEGIN
        IF c%NOTFOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%NOTFOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'After OPEN, Before FETCH - ROWCOUNT : ';
    BEGIN
        IF c%ROWCOUNT IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            DBMS_OUTPUT.PUT_LINE(step || c%ROWCOUNT);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    LOOP
        FETCH c INTO code, name;
        step := 'After FETCH - ISOPEN : ';
        BEGIN
            IF c%ISOPEN IS NULL THEN
                DBMS_OUTPUT.PUT_LINE(step || 'NULL');
            ELSE
                CASE c%ISOPEN 
                    WHEN TRUE THEN
                        DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                    WHEN FALSE THEN
                        DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                    ELSE
                        RAISE_APPLICATION_ERROR(1001, step || ' error ');
                END CASE;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
        END;

        step := 'After FETCH - FOUND : ';
        BEGIN
            IF c%FOUND IS NULL THEN
                DBMS_OUTPUT.PUT_LINE(step || 'NULL');
            ELSE
                CASE c%FOUND 
                    WHEN TRUE THEN
                        DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                    WHEN FALSE THEN
                        DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                    ELSE
                        RAISE_APPLICATION_ERROR(1001, step || ' error ');
                END CASE;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
        END;

        step := 'After FETCH - NOTFOUND : ';
        BEGIN
            IF c%NOTFOUND IS NULL THEN
                DBMS_OUTPUT.PUT_LINE(step || 'NULL');
            ELSE
                CASE c%NOTFOUND 
                    WHEN TRUE THEN
                        DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                    WHEN FALSE THEN
                        DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                    ELSE
                        RAISE_APPLICATION_ERROR(1001, step || ' error ');
                END CASE;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
        END;

        step := 'After FETCH - ROWCOUNT : ';
        BEGIN
            IF c%ROWCOUNT IS NULL THEN
                DBMS_OUTPUT.PUT_LINE(step || 'NULL');
            ELSE
                DBMS_OUTPUT.PUT_LINE(step || c%ROWCOUNT);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
        END;

        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('code: ' || code || ' name: ' || name);
    END LOOP;

    step := 'Before CLOSE - ISOPEN : ';
    BEGIN
        IF c%ISOPEN IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%ISOPEN 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'Before CLOSE - FOUND : ';
    BEGIN
        IF c%FOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%FOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'Before CLOSE - NOTFOUND : ';
    BEGIN
        IF c%NOTFOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%NOTFOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'Before CLOSE - ROWCOUNT : ';
    BEGIN
        IF c%ROWCOUNT IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            DBMS_OUTPUT.PUT_LINE(step || c%ROWCOUNT);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    CLOSE c;
    
    step := 'After CLOSE - ISOPEN : ';
    BEGIN
        IF c%ISOPEN IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%ISOPEN 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'After CLOSE - FOUND : ';
    BEGIN
        IF c%FOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%FOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'After CLOSE - NOTFOUND : ';
    BEGIN
        IF c%NOTFOUND IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            CASE c%NOTFOUND 
                WHEN TRUE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'TRUE');
                WHEN FALSE THEN
                    DBMS_OUTPUT.PUT_LINE(step || 'FALSE');
                ELSE
                    RAISE_APPLICATION_ERROR(1001, step || ' error ');
            END CASE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;

    step := 'After CLOSE - ROWCOUNT : ';
    BEGIN
        IF c%ROWCOUNT IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(step || 'NULL');
        ELSE
            DBMS_OUTPUT.PUT_LINE(step || c%ROWCOUNT);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(step || SQLERRM || '(' || SQLCODE || ')');
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('code=' || SQLCODE || ', message=' || SQLERRM);
        CLOSE c;
END;


call cursor_status_nation_athletes();
drop procedure cursor_status_nation_athletes;
drop table if exists athlete_t;
