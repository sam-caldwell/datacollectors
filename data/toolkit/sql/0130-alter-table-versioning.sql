/*
 * ensure the versioning table requires install_date to be in the future.
 */
DO
$$
    begin
        call toolkit.ensureFutureTimestamp('versioning', 'install_date');
    end
$$ language plpgsql;