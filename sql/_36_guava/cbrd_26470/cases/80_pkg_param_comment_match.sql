/**
 *  This test case verifies CBRD-26470 (PR #7819): parameter COMMENTs in the comparison of the
 *  routine headers of a package specification and body (review round 6, E6).
 *
 *  When a parameter COMMENT differed between the specification and the body (or was only on one
 *  side), the body was refused with s114 "the header of ... in the package body does not match
 *  that in the package specification". The header comparison (DeclRoutine.givesBodyOf) compared
 *  the whole normalized text of routine_header; parameter COMMENTs are inside the header while a
 *  routine COMMENT is outside, so only a routine COMMENT could differ. The catalog keeps only the
 *  COMMENTs of the specification.
 *  Fix: parameter COMMENTs are left out of the header comparison.
 *
 *  Coverage:
 *    Case 1: parameter COMMENT only in the specification -> created, catalog has the spec one
 *    Case 2: different parameter COMMENTs                -> created, catalog has the spec one
 *    Case 3: parameter COMMENT only in the body          -> created, no catalog comment
 *    Case 4: OUT parameter of a function, COMMENT only in the specification -> created and runs
 *    Case 5: different parameter types                   -> s114
 *    Case 6: different default strings (a and b)         -> s114
 *    Case 7: only the routine COMMENTs differ            -> created
 */

--+ server-message on

drop package if exists pc80_1;
drop package if exists pc80_2;
drop package if exists pc80_3;
drop package if exists pc80_4;
drop package if exists pc80_5;
drop package if exists pc80_6;
drop package if exists pc80_7;


evaluate 'Case 1: parameter COMMENT only in the specification -> created, catalog comment ''first arg''';
CREATE OR REPLACE PACKAGE pc80_1 AS
  PROCEDURE p(a INT COMMENT 'first arg');
END;
CREATE OR REPLACE PACKAGE BODY pc80_1 AS
  PROCEDURE p(a INT) AS
  BEGIN
    NULL;
  END;
END;
select arg_name, comment from db_stored_procedure_args where pkg_name = 'pc80_1' order by arg_name;

evaluate 'Case 2: different parameter COMMENTs -> created, catalog comment ''spec arg''';
CREATE OR REPLACE PACKAGE pc80_2 AS
  PROCEDURE p(a INT COMMENT 'spec arg');
END;
CREATE OR REPLACE PACKAGE BODY pc80_2 AS
  PROCEDURE p(a INT COMMENT 'body arg') AS
  BEGIN
    NULL;
  END;
END;
select arg_name, comment from db_stored_procedure_args where pkg_name = 'pc80_2' order by arg_name;

evaluate 'Case 3: parameter COMMENT only in the body -> created, catalog comment NULL';
CREATE OR REPLACE PACKAGE pc80_3 AS
  PROCEDURE p(a INT);
END;
CREATE OR REPLACE PACKAGE BODY pc80_3 AS
  PROCEDURE p(a INT COMMENT 'body arg') AS
  BEGIN
    NULL;
  END;
END;
select arg_name, comment from db_stored_procedure_args where pkg_name = 'pc80_3' order by arg_name;

evaluate 'Case 4: OUT parameter of a function, COMMENT only in the specification -> created, call = 9';
CREATE OR REPLACE PACKAGE pc80_4 AS
  FUNCTION f(a INT COMMENT 'in arg', b OUT INT COMMENT 'out arg') RETURN INT;
  FUNCTION g RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pc80_4 AS
  FUNCTION f(a INT, b OUT INT) RETURN INT AS
  BEGIN
    b := a * 2;
    RETURN a;
  END;
  FUNCTION g RETURN INT AS
    x INT;
  BEGIN
    RETURN f(3, x) + x;
  END;
END;
CREATE OR REPLACE FUNCTION w80_4 RETURN INT AS
BEGIN
  RETURN pc80_4.g();
END;
select w80_4() from dual;

evaluate 'Case 5: different parameter types -> s114 header mismatch';
CREATE OR REPLACE PACKAGE pc80_5 AS
  PROCEDURE p(a INT COMMENT 'arg');
END;
CREATE OR REPLACE PACKAGE BODY pc80_5 AS
  PROCEDURE p(a BIGINT COMMENT 'arg') AS
  BEGIN
    NULL;
  END;
END;

evaluate 'Case 6: different default strings -> s114 header mismatch';
CREATE OR REPLACE PACKAGE pc80_6 AS
  PROCEDURE p(a VARCHAR DEFAULT 'a' COMMENT 'arg');
END;
CREATE OR REPLACE PACKAGE BODY pc80_6 AS
  PROCEDURE p(a VARCHAR DEFAULT 'b' COMMENT 'arg') AS
  BEGIN
    NULL;
  END;
END;

evaluate 'Case 7: different routine COMMENTs -> created';
CREATE OR REPLACE PACKAGE pc80_7 AS
  PROCEDURE p(a INT) COMMENT 'spec routine';
END;
CREATE OR REPLACE PACKAGE BODY pc80_7 AS
  PROCEDURE p(a INT) AS
  BEGIN
    NULL;
  END COMMENT 'body routine';
END;


drop function w80_4;
drop package if exists pc80_1;
drop package if exists pc80_2;
drop package if exists pc80_3;
drop package if exists pc80_4;
drop package if exists pc80_5;
drop package if exists pc80_6;
drop package if exists pc80_7;

--+ server-message off
