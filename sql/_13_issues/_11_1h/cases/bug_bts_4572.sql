--Test LIKE operator with a NULL escape sequence
--+ holdcas on;

DROP TABLE IF EXISTS dml_0001;
CREATE TABLE dml_0001(b VARCHAR(10));

SET SYSTEM PARAMETERS 'compat_mode=mysql';
INSERT INTO dml_0001 VALUES ('bzaa'), ('bzaa%'), ('bzaa\%'), ('bzaaXaa'), ('bzaa%Xaa'), ('bzaa_'), ('bzaa\_'), ('bzaa_yy'), ('bzaa\_yy');

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa%';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa%', '\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa%', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\%%a';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\%%a', '\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\%%a', NULL;


SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa_';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa_', '\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa_', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\___';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\___', '\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\___', NULL;

SELECT ('StrXing' LIKE 'Str%ing');
SELECT ('StrXing' LIKE 'Str%ing' ESCAPE '\\');
SELECT ('StrXing' LIKE 'Str%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE ?)'
EXECUTE stmt USING 'StrXing', 'Str%ing';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str%ing', '\\';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str%ing', NULL;

SELECT ('StrXing' LIKE 'Str\%ing');
SELECT ('StrXing' LIKE 'Str\%ing' ESCAPE '\\');
SELECT ('StrXing' LIKE 'Str\%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE ?)'
EXECUTE stmt USING 'StrXing', 'Str\%ing';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str\%ing', '\\';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str\%ing', NULL;

SELECT ('Str%ing' LIKE 'Str\%%g');
SELECT ('Str%ing' LIKE 'Str\%%g' ESCAPE '\\');
SELECT ('Str%ing' LIKE 'Str\%%g' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE ?)'
EXECUTE stmt USING 'Str%ing', 'Str\%%g';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'Str%ing', 'Str\%%g', '\\';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'Str%ing', 'Str\%%g', NULL;

-- Test LIKE with NCHAR variables
DROP TABLE dml_0001;
CREATE TABLE dml_0001(b NCHAR VARYING(10));
INSERT INTO dml_0001 VALUES (N'bzaa'), (N'bzaa%'), (N'bzaa\%'), (N'bzaaXaa'), (N'bzaa%Xaa'), (N'bzaa_'), (N'bzaa\_'), (N'bzaa_yy'), (N'bzaa\_yy');
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa%' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa%' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa%' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa%';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa%', N'\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa%', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\%%a' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\%%a' ESCAPE N'\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\%%a' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\%%a';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\%%a', N'\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\%%a', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa_' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa_' ESCAPE N'\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa_' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa_';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa_', N'\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa_', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE '\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\___' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\___' ESCAPE N'\\' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\___' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\___';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\___', N'\\';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\___', NULL;

SELECT (N'StrXing' LIKE 'Str%ing');
SELECT (N'StrXing' LIKE 'Str%ing' ESCAPE '\\');
SELECT (N'StrXing' LIKE 'Str%ing' ESCAPE NULL);

SELECT (N'StrXing' LIKE N'Str%ing');
SELECT (N'StrXing' LIKE N'Str%ing' ESCAPE N'\\');
SELECT (N'StrXing' LIKE N'Str%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ?)'
EXECUTE stmt USING N'Str%ing';

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str%ing', N'\\';

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str%ing', NULL;

SELECT (N'StrXing' LIKE 'Str\%ing');
SELECT (N'StrXing' LIKE 'Str\%ing' ESCAPE '\\');
SELECT (N'StrXing' LIKE 'Str\%ing' ESCAPE NULL);

SELECT (N'StrXing' LIKE N'Str\%ing');
SELECT (N'StrXing' LIKE N'Str\%ing' ESCAPE N'\\');
SELECT (N'StrXing' LIKE N'Str\%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ?)'
EXECUTE stmt USING N'Str\%ing';

PREPARE stmt FROM 'SELECT (N''StrXing''  LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str\%ing', N'\\';

PREPARE stmt FROM 'SELECT (N''StrXing''  LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str\%ing', NULL;

SELECT (N'Str%ing' LIKE 'Str\%%g');
SELECT (N'Str%ing' LIKE 'Str\%%g' ESCAPE '\\');
SELECT (N'Str%ing' LIKE 'Str\%%g' ESCAPE NULL);

SELECT (N'Str%ing' LIKE N'Str\%%g');
SELECT (N'Str%ing' LIKE N'Str\%%g' ESCAPE N'\\');
SELECT (N'Str%ing' LIKE N'Str\%%g' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE N''Str\%%g'')'
EXECUTE stmt USING N'Str%ing';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE N''\\\\'')'
EXECUTE stmt USING N'Str%ing', N'Str\%%g';

PREPARE stmt FROM 'SELECT (? LIKE N''Str\%%g'' ESCAPE ?)'
EXECUTE stmt USING N'Str%ing', NULL;

DROP TABLE dml_0001;

--
-- Test LIKE with ESCAPE NULL in compat_mode=cubrid
--
CREATE TABLE dml_0001(b VARCHAR(10));

SET SYSTEM PARAMETERS 'compat_mode=cubrid';
INSERT INTO dml_0001 VALUES ('bzaa'), ('bzaa%'), ('bzaa\%'), ('bzaaXaa'), ('bzaa%Xaa'), ('bzaa_'), ('bzaa\_'), ('bzaa_yy'), ('bzaa\_yy');

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa%';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa%', '\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa%', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\%%a';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\%%a', '\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\%%a', NULL;


SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa_';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa_', '\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa_', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\___';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\___', '\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING 'bzaa\___', NULL;

SELECT ('StrXing' LIKE 'Str%ing');
SELECT ('StrXing' LIKE 'Str%ing' ESCAPE '\');
-- ' --
SELECT ('StrXing' LIKE 'Str%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE ?)'
EXECUTE stmt USING 'StrXing', 'Str%ing';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str%ing', '\';
-- ' --

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str%ing', NULL;

SELECT ('StrXing' LIKE 'Str\%ing');
SELECT ('StrXing' LIKE 'Str\%ing' ESCAPE '\');
-- ' --
SELECT ('StrXing' LIKE 'Str\%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE ?)'
EXECUTE stmt USING 'StrXing', 'Str\%ing';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str\%ing', '\';
-- ' --

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'StrXing', 'Str\%ing', NULL;

SELECT ('Str%ing' LIKE 'Str\%%g');
SELECT ('Str%ing' LIKE 'Str\%%g' ESCAPE '\');
-- ' --
SELECT ('Str%ing' LIKE 'Str\%%g' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE ?)'
EXECUTE stmt USING 'Str%ing', 'Str\%%g';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'Str%ing', 'Str\%%g', '\';
-- ' --

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE ?)'
EXECUTE stmt USING 'Str%ing', 'Str\%%g', NULL;

-- Test LIKE with NCHAR variables
DROP TABLE dml_0001;
CREATE TABLE dml_0001(b NCHAR VARYING(10));
INSERT INTO dml_0001 VALUES (N'bzaa'), (N'bzaa%'), (N'bzaa\%'), (N'bzaaXaa'), (N'bzaa%Xaa'), (N'bzaa_'), (N'bzaa\_'), (N'bzaa_yy'), (N'bzaa\_yy');
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa%' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa%' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa%' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa%' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa%';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa%', N'\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa%', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\%%a' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\%%a' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\%%a' ESCAPE N'\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\%%a' ESCAPE NULL ORDER BY 1;
PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\%%a';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\%%a', N'\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\%%a', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa_' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa_' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa_' ESCAPE N'\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa_' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa_';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa_', N'\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa_', NULL;

SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE '\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE 'bzaa\___' ESCAPE NULL ORDER BY 1;

SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\___' ORDER BY 1;
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\___' ESCAPE N'\' ORDER BY 1;
-- ' --
SELECT * FROM dml_0001 WHERE b LIKE N'bzaa\___' ESCAPE NULL ORDER BY 1;

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\___';

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\___', N'\';
-- ' --

PREPARE stmt FROM 'SELECT * FROM dml_0001 WHERE b LIKE ? ESCAPE ? ORDER BY 1'
EXECUTE stmt USING N'bzaa\___', NULL;

SELECT (N'StrXing' LIKE 'Str%ing');
SELECT (N'StrXing' LIKE 'Str%ing' ESCAPE '\');
-- ' --
SELECT (N'StrXing' LIKE 'Str%ing' ESCAPE NULL);

SELECT (N'StrXing' LIKE N'Str%ing');
SELECT (N'StrXing' LIKE N'Str%ing' ESCAPE N'\');
-- ' --
SELECT (N'StrXing' LIKE N'Str%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ?)'
EXECUTE stmt USING N'Str%ing';

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str%ing', N'\';
-- ' --

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str%ing', NULL;

SELECT (N'StrXing' LIKE 'Str\%ing');
SELECT (N'StrXing' LIKE 'Str\%ing' ESCAPE '\');
-- ' --
SELECT (N'StrXing' LIKE 'Str\%ing' ESCAPE NULL);

SELECT (N'StrXing' LIKE N'Str\%ing');
SELECT (N'StrXing' LIKE N'Str\%ing' ESCAPE N'\');
-- ' --
SELECT (N'StrXing' LIKE N'Str\%ing' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (N''StrXing'' LIKE ?)'
EXECUTE stmt USING N'Str\%ing';

PREPARE stmt FROM 'SELECT (N''StrXing''  LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str\%ing', N'\';
-- ' --

PREPARE stmt FROM 'SELECT (N''StrXing''  LIKE ? ESCAPE ?)'
EXECUTE stmt USING N'Str\%ing', NULL;

SELECT (N'Str%ing' LIKE 'Str\%%g');
SELECT (N'Str%ing' LIKE 'Str\%%g' ESCAPE '\');
-- ' --
SELECT (N'Str%ing' LIKE 'Str\%%g' ESCAPE NULL);

SELECT (N'Str%ing' LIKE N'Str\%%g');
SELECT (N'Str%ing' LIKE N'Str\%%g' ESCAPE N'\');
-- ' --
SELECT (N'Str%ing' LIKE N'Str\%%g' ESCAPE NULL);

PREPARE stmt FROM 'SELECT (? LIKE N''Str\%%g'')'
EXECUTE stmt USING N'Str%ing';

PREPARE stmt FROM 'SELECT (? LIKE ? ESCAPE N''\'')'
EXECUTE stmt USING N'Str%ing', N'Str\%%g';
-- ' --

PREPARE stmt FROM 'SELECT (? LIKE N''Str\%%g'' ESCAPE ?)'
EXECUTE stmt USING N'Str%ing', NULL;

DROP TABLE dml_0001;

COMMIT;

--+ holdcas off;

