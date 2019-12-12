SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": null}');
SELECT JSON_MERGE_PRESERVE('{"name": "x"}', '{"id": null}');
