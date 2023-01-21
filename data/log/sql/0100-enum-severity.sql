/*
 * Event severity helps segment the important errors from more informative events.
 * We could have used tags here, but a tag would be available to all areas of the
 * environment and we are only concerned with severity of the events.
 */
call toolkit.create_enum('log.severity', ARRAY ['critical','error','info', 'debug']);