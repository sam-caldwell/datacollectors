create or replace function toolkit.hash(s varchar) returns varchar as
$$
    begin
        return encode(sha256(convert_to(s,'UTF8')),'hex');
    end
$$ language plpgsql;