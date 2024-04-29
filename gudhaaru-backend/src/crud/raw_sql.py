get_new_item_id = """
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN FLOOR(RAND() * (100000 - 1001 + 1) + 1001) 
        ELSE (
            SELECT FLOOR(RAND() * (100000 - 1001 + 1) + 1001) 
            FROM `attribute_value` 
            WHERE FLOOR(RAND() * (100000 - 1001 + 1) + 1001) NOT IN (SELECT `item_id` FROM `attribute_value`)
            LIMIT 1
        )
    END AS new_id
FROM `attribute_value`;
"""