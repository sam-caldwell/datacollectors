/*
    Races:
        A - Asian or Pacific Islander
        B - Black
        H - Hispanic
        I - American Indian
        U - Unknown
        W - White
 */
call people.create_enum('people.Races',
                        ARRAY ['A','B','H','I','U','W']);
