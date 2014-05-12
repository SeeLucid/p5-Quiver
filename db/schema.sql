CREATE TABLE IF NOT EXISTS symtype (
	symtypeid INTEGER PRIMARY KEY,
	name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS symbol (
	symboluid INTEGER PRIMARY KEY, -- rowid

	name TEXT,                   -- symbol name [ e.g., printf ]

	symtypeid INTEGER NOT NULL,  -- symbol type from TABLE `symtype` [ e.g., ( N, 'function prototype' ) ]

	scanfilemetaid INTEGER,      -- filename where the symbol is defined [ e.g., /usr/include/stdio.h ]

	linestart INTEGER NOT NULL,  -- an integer indicating the first line (1-based index) that symbol appears on

	lineend INTEGER,             -- an integer indicating the last line of the symbol (set to NULL if not known)

	uri TEXT,                    -- backend-specific lookup [ e.g. ctags:... ]

	scanid INTEGER NOT NULL,

	FOREIGN KEY(symtypeid) REFERENCES symtype(symtypeid),
	FOREIGN KEY(scanfilemetaid) REFERENCES scanfilemeta(scanfilemetaid) ON DELETE CASCADE,
	FOREIGN KEY(scanid) REFERENCES scan(scanid)
);

CREATE TABLE IF NOT EXISTS symboltext (
	symboluid INTEGER PRIMARY KEY,
	symboltext TEXT NOT NULL,

	FOREIGN KEY(symboluid) REFERENCES symbol(symboluid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS scan (
	scanid INTEGER PRIMARY KEY,
	sourceid INTEGER NOT NULL,
	timestarted INTEGER NOT NULL,  --- timestamp

	FOREIGN KEY(sourceid) REFERENCES source(sourceid)
);

CREATE TABLE IF NOT EXISTS scanfilemeta (
	scanfilemetaid INTEGER PRIMARY KEY,
	filename TEXT NOT NULL UNIQUE,       -- path to file
	timelastmod INTEGER NOT NULL         -- timestamp: time last modified
);

CREATE TABLE IF NOT EXISTS source (
	sourceid INTEGER PRIMARY KEY,
	name TEXT NOT NULL UNIQUE     --- e.g., Ctags, RegexpCommon, etc.
);
