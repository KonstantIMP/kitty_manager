// Define database module
module kimp.database;

// Import exceptions, files and JSON
import std.exception, std.json, std.file, std.conv;

/// Contain current database's version
immutable ubyte DATABASE_VERSION = 0;

/**
 * Excepion class for DatabaseHelper
 * See_Also: DatabaseHelper, Exception
 */
class DatabaseException : Exception {
    /**
     * Default constructor for DatabaseException
     * Params:
     *     msg = Excpetion's message (With error)
     *     file = Exception file
     *     line = Exception line
     */
    this(string msg, string file = __FILE__, size_t line = __LINE__) @safe {
        super(msg, file, line); // Just call parent's constructor
    }
}

/**
 * Helper class for working with local passwords database
 * Authors: KonstantIMP, mihedovkos@gmail.com
 * Date: May 19, 2021
 * See_Also: DatabaseException
 */
class DatabaseHelper {
    /**
     * Init Helper's data and database
     * Check for the existence of the database and create it if the file is not found
     * Throws:
     *     DatabaseException if the database is invalid
     *     ErrnoException if the database cannot be created or opened
     */
    public this(immutable string db_file = "kitty.db") @safe {
        // Check database
        if (exists(db_file) == true && isFile(db_file) == true) {
            memory_db = parseJSON(readText(db_file));

            if ("version" !in memory_db || "users" !in memory_db) {
                throw new DatabaseException("Incorrect database! Fix it yourself...");
            }

            if (memory_db["version"].integer != DATABASE_VERSION) {
                onUpdate(to!ubyte(memory_db["versiodbn"].integer));
            }
        }
        else {
            memory_db = parseJSON("{}");
            memory_db["version"] = DATABASE_VERSION;
            memory_db["users"] = parseJSON("[]");

            write(db_file, memory_db.toString());
        }

        db = db_file;
    }

    /**
     * Update database for new version
     * Params:
     *     last_version = Previous database's version
     * Throws:
     *     DatabaseException if cannot update database
     */
    private void onUpdate(immutable ubyte last_version) @safe {
        // Hothing here
    }

    /// Database's file name
    private immutable string db;
    /// Memory database
    private JSONValue memory_db;
}
