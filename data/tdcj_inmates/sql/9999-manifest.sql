create or replace procedure setup() AS
$$
begin
    /* extensions */
    call create_0000_create_extension_uuid();

    raise notice 'Create types';
    call create_0001_types_genders();
    call create_0001_types_job_status();
    call create_0001_types_date_types();
    call create_0001_types_races();

    raise notice 'Create notes tables';
    call create_0030_table_note_set();
    call create_0030_table_notes();

    raise notice 'Create identity tables';
    call create_0020_table_facilities();
    call create_0020_table_stage1_raw();
    call create_0020_table_stage2_raw();
    call create_0020_table_last_names();
    call create_0020_table_first_names();
    call create_0030_table_identity();

    raise notice 'Create demographic tables';
    call create_0040_table_roster();
    call create_0045_table_tdcj_id_numbers();
    call create_0050_table_inmate_age();
    call create_0060_table_offense_history();
    call create_0070_table_parole_review();
    call create_0080_table_release_dates();
    call create_0090_table_visitation_eligibility();
    call create_0110_table_current_facility();
    call create_0120_table_release_information();
end
$$ language plpgsql;

call setup();
