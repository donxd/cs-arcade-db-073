/*Please add ; after each select statement*/
CREATE PROCEDURE queriesExecution()
BEGIN
    DECLARE vdone INT;
    DECLARE vname TEXT;
    DECLARE equery TEXT;
    DECLARE curs CURSOR FOR SELECT query_name, `code` FROM queries;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdone = 1;

    CREATE TABLE IF NOT EXISTS results (
        query_name TEXT, 
        `code` TEXT
    );
    
    TRUNCATE results;
    
    SET @result = '';
    SET @n = 1;
    SET @limit = (SELECT COUNT(*) FROM queries);

    SET vdone = 0;
    OPEN curs;

    REPEAT
    -- WHILE @n < @limit
        FETCH curs INTO vname, equery;
        SET @query = CONCAT('INSERT INTO results VALUES ("', vname ,'", (', equery ,'))');
        PREPARE stmt FROM @query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT (@n + 1) INTO @n;
        -- SET 
    UNTIL (@n > @limit) END REPEAT;
    -- END WHILE;

    CLOSE curs;

    SELECT 
     query_name
    , `code` as val
    -- , @n
    -- , @limit
    FROM results
    ;
END