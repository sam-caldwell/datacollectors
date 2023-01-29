/*
 * write a record to the log.events table if the severity is greater than
 * the current db.log.severity value in our config data.
 */
create or replace procedure log.write(_severity log.severity, _key varchar,
                                      _value decimal, _tags varchar[]) AS
$$
declare
    current_level log.severity := config.get('db.log.severity', true)::log.severity;
    tagIds        integer[]    := log.getTagSet(_tags);
begin
    if current_level >= _severity then
        insert into log.events(key, value, tags, severity)
        values (_key, _value, tagIds, _severity);
    end if;
end
$$ language plpgsql;
