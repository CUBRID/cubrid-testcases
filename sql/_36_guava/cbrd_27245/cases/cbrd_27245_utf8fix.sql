/**
 * This test case verifies CBRD-27245: Improve lexer input handling for UTF-8 statements
 *
 * Coverage: a 4-byte UTF-8 character (U+21861 = F0 A1 A1 A1) whose trailing two
 * bytes coincide with the EUC-KR full-width space (0xA1A1). The old DBCS filter
 * (applied to any variable-length charset, including UTF-8) folded that byte
 * pair to two spaces outside string literals, corrupting the character and, in
 * one case, splitting the token stream. Inside a literal it was never affected.
 * 1 - the character inside a string literal (always correct, control case)
 * 2 - the character alone as an identifier alias (outside a literal)
 * 3 - the character followed by another identifier byte in the same alias
 */

evaluate 'Case 1: multi-byte UTF-8 character inside a string literal (control)';
SELECT '𡡡', OCTET_LENGTH('𡡡') FROM db_root;

evaluate 'Case 2: multi-byte UTF-8 character as an alias, outside any literal';
SELECT 1 AS t𡡡 FROM db_root;

evaluate 'Case 3: multi-byte UTF-8 character followed by another byte in an alias';
SELECT 1 AS t𡡡x FROM db_root;
