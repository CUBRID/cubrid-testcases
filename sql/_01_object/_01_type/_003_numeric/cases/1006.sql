-- create class with numberic using every length and 
create class c_n (

    c1 NUMERIC PRIMARY KEY,
    c2 NUMERIC(5) DEFAULT 0 NOT NULL,
    c3 NUMERIC(9,4) UNIQUE NOT NULL,
    c4 NUMERIC(4,4) SHARED 0.1 NOT NULL
    );
drop c_n;
