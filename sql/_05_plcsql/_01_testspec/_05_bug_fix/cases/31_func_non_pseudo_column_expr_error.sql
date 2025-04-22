--+ server-message on
-- verified the CBRD-26021
-- Fix NULL default when using non-pseudo column expressions in a stored function' parameter

-- Error : -493 non-default
CREATE OR REPLACE FUNCTION t (a int RAND()) RETURN int as begin return a; end;

-- compile success : rand function
CREATE OR REPLACE FUNCTION t (a int default RAND()) RETURN int as begin return a; end;

-- Error : -493 non-default
CREATE OR REPLACE function t1 (a int log(4,2)) return int as begin return a; end;

-- compile success : add log function  
CREATE OR REPLACE function t1 (a int default log(4,2)) return int as begin return a; end;

-- default_value
SELECT default_value FROM db_stored_procedure_args WHERE sp_name = 't1';

-- Error : -493 invalid create statement
CREATE OK REPLACE FUNCTION t2 (a int logk(4,2)) return int as begin return a; end;

-- Error : -493 invalid create statement
CREATE OK REPLACE FUNCTION t2 (a int default logk(4,2)) return int as begin return a; end;

DROP FUNCTION t;
DROP FUNCTION t1;

--+ server-message off
