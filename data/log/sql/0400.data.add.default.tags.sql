/*
 * Add the default tags
 */
DO
$$
    begin
        /* environment tags */
        call log.addTag('env:dev');
        call log.addTag('env:stage');
        call log.addTag('env:prod');
        /* service tags */
        call log.addTag('svc:datacollectors');
        call log.addTag('svc:kubernetes');
        call log.addTag('svc:kafka');
    end
$$ language plpgsql;