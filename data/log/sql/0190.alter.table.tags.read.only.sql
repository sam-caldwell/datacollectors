/*
 * Alter the log.tags table to make it read only.
 */
DO
$$
    begin
        call log.tagsReadOnly();
    end
$$ language plpgsql;