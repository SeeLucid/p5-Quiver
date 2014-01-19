CREATE TABLE symtype (
	id INTEGER PRIMARY KEY,
	name TEXT NOT NULL
);

INSERT INTO symtype VALUES ( 1, 'function definition' );
INSERT INTO symtype VALUES ( 2, 'comment' );
INSERT INTO symtype VALUES ( 3, 'documentation' );
