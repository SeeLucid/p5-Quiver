CREATE TABLE IF NOT EXISTS symtype (
	symtypeid INTEGER PRIMARY KEY,
	name TEXT NOT NULL
);

INSERT INTO symtype (name) VALUES ( 'function definition' );
INSERT INTO symtype (name) VALUES (  'function prototype' );
INSERT INTO symtype (name) VALUES (             'comment' );
INSERT INTO symtype (name) VALUES (       'documentation' );
INSERT INTO symtype (name) VALUES (               'macro' );

CREATE TABLE IF NOT EXISTS symbol (
	symboluid INTEGER PRIMARY KEY, -- rowid

	name TEXT,                   -- symbol name [ e.g., printf ]

	symtypeid INTEGER,           -- symbol type from TABLE `symtype` [ e.g., ( N, 'function prototype' ) ]

	filename TEXT,               -- filename where the symbol is defined [ e.g., /usr/include/stdio.h ]

	linestart INTEGER NOT NULL,  -- an integer indicating the first line (1-based index) that symbol appears on

	lineend INTEGER,             -- an integer indicating the last line of the symbol (set to NULL if not known)

	uri TEXT,                    -- backend-specific lookup [ e.g. ctags:... ]

	scanid INTEGER,

	FOREIGN KEY(symtypeid) REFERENCES symtype(symtypeid)
	FOREIGN KEY(scanid) REFERENCES scan(scanid)
);

CREATE TABLE IF NOT EXISTS symboltext (
	symboluid INTEGER PRIMARY KEY,
	symboltext TEXT,

	FOREIGN KEY(symboluid) REFERENCES symbol(symboluid)
);

CREATE TABLE IF NOT EXISTS scan (
	scanid INTEGER,
	sourcename TEXT,
	timestarted INTEGER
);

CREATE TABLE IF NOT EXISTS scanfilemeta (
	scanid INTEGER,
	filename TEXT,
	timelastmod INTEGER,
	md5sum TEXT,

	FOREIGN KEY(scanid) REFERENCES scan(scanid)
);
