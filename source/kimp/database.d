// Define database module
module kimp.database;

// Import exceptions, files and JSON
import std.exception, std.json, std.file, std.conv;

// Import crypting libraries
import std.digest.sha, std.algorithm;

// Import kimp modules
import kimp.cli;

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
 *
 * Database structure :
 * - file.db
 *   - version
 *   - users
 *     - name
 *     - password
 *     - saves
 *       - website
 *       - login
 *       - password
 *
 * Authors: KonstantIMP, mihedovkos@gmail.com
 * Date: May 19, 2021
 * See_Also: DatabaseException
 */
class DatabaseHelper {
    /**
     * Init Helper's data and database
     *
     * Check for the existence of the database and create it if the file is not found
     * Throws:
     *     DatabaseException if the database is invalid
     *
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
                onUpdate(to!ubyte(memory_db["version"].integer));
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
        Cli.printWarning("Migrate database from " ~ to!string(last_version) ~ " to " ~ to!string(DATABASE_VERSION));
    }

    /**
     * Get Users num from memory db
     * Returns:
     *     Users num in the database
     */
    public ulong getUsersNum() @trusted {
        return memory_db["users"].array().length;
    }

    /**
     * Backup the database
     * Params:
     *     backup_file = Path for backup file
     * Throws:
     *     ErrnoException if cannot create backup file
     *
     *     DatabaseException if backup already exist
     */
    public void backup(immutable string backup_file) @safe {
        enforce!DatabaseException(exists(backup_file) == false, "File with name \"" ~ backup_file ~ "\" already exist");
        write(backup_file, memory_db.toString());
    }

    /**
     * Check user existion in the database
     * Params:
     *     username = Username for checking
     * Returns:
     *     true if the user exists
     */
    public bool checkUser(immutable string username) @trusted {
        foreach (i; memory_db["users"].array()) {
            if (i["name"].str() == username) return true;
        }
        return false;
    }

    /**
     * Create new User recod in database
     * Params:
     *     username = Name for new user
     *     password = Password for new user
     * Throws:
     *     DatabaseExcpetion if the user already exists
     *     FileException if cannot write db
     */
    public void addUser(immutable string username, immutable string password) @trusted {
        enforce!DatabaseException(this.checkUser(username) == false, "The user already exists");
        auto user_record = JSONValue(["name" : username, "password" : sha256Of(password).toHexString()]);
        user_record["saves"] = parseJSON("[]"); memory_db["users"].array() ~= user_record;
        this.writeDB();
    }

    /**
     * Remove user from the database
     * Params:
     *     username = Name of user for delete
     *     password = Password for the confirmation
     * Throws:
     *     DatabaseException if the user doesn't exist or password is incorrect
     *     FileException if cannot write db
     */
    public void removeUser(immutable string username, immutable string password) @trusted {
        enforce!DatabaseException(this.checkUser(username), "The user doesn\'t exist");
        JSONValue tmp_users = parseJSON("[]");
        foreach(i, e; memory_db["users"].array()) {
            if (e["name"].str() == username) {
                enforce!DatabaseException(sha256Of(password).toHexString() == e["password"].str(), "Incorrect password");
            }
            else tmp_users.array() ~= e;
        }
        memory_db["users"] = tmp_users; this.writeDB();
    }

    /**
     * Collect saved websites
     * Params:
     *     username = Name for authentication
     *     password = Password for authentication
     * Throws:
     *     DatabaseException if cannot auth the user
     * Returns:
     *     String array with website's names
     */
    public string [] getWebsites(immutable string username, immutable string password) @trusted {
        string [] websites; websites.length = 0;
        this.authenticate(username, password);

        foreach(u; memory_db["users"].array()) {
            if (u["name"].str() == username) {
                foreach(e; u["saves"].array()) {
                    websites.length = websites.length + 1;
                    websites[$ - 1] = e["website"].str();
                } break;
            }
        }

        return websites;
    }

    /**
     * Try to auth the user and check its password
     * Params:
     *     username = Name for authentication
     *     password = Password for getting access
     * Throws:
     *     DatabaseException is password is incorrect or user doesn't exist
     * Returns:
     *     true if authentification is complete
     */
    public void authenticate(immutable string username, immutable string password) @trusted {
        enforce!DatabaseException(this.checkUser(username), "The user doesn\'t exist");
        foreach (e; memory_db["users"].array()) {
            if(e["name"].str() == username) {
                enforce!DatabaseException(sha256Of(password).toHexString() == e["password"].str(), "Incorrect password");
            }
        }
    }

    /**
     * Write the current database to the file
     * Throws:
     *     FileException if cannot write db
     */
    private void writeDB() @safe {
        write(db, memory_db.toString());
    }

    /// Database's file name
    private immutable string db;
    /// Memory database
    private JSONValue memory_db;
}
