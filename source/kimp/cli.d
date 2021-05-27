// Define kimp.cli module
module kimp.cli;

// Import stdio and defines
import std.stdio, std.string, std.conv, kimp.defines;

// Import exceptions
import std.exception, kimp.database : DatabaseException;

/**
 * Class for work with CLI
 * Print hello and help messages, get data from keyboard
 */
class Cli {
    /**
     * Print default hello message for KittyManager
     */
    public static void printHello() @safe {
        writeln(" _  ___ _   _         __  __\t\t", PACKAGE_NAME);
        writeln("| |/ (_| |_| |_ _   _|  \\/  |\t\tVersion : ", MAJOR_VERSION, '.', MINOR_VERSION, '.', BUILD_VERSION);
        writeln("| \' /| | __| __| | | | |\\/| |");
        writeln("| . \\| | |_| |_| |_| | |  | |_\t\tPowered by KonstantIMP");
        writeln("|_|\\_|_|\\__|\\__|\\__, |_|  |_(_)\t\tFeedback email : mihedovkos@gmail.com");
        writeln("                |___/");
        writeln("");
    }

    /**
     * Print help message with cli options
     */
    public static void printHelp() @safe {
        writeln("USAGE : kitty_m [OPTIONS]");
        writeln("OPTIONS :");
        writeln("  -h|--help\t\t\tPrint this message and exit");
        writeln("  -v|--version\t\t\tPrint KittyManager version and exit");
        writeln("  -a|--add\t\t\tCreate new user (Just with -u and -p)");
        writeln("  -r|--remove\t\t\tRemove user (Just with -u and -p)");
        writeln("  -u|--user [USERNAME]\t\tLogin for data getting");
        writeln("  -p|--passwd [PASSWORD]\tPassword for -u flag");
        writeln("  -b|--backup [FILENAME]\tBackup local database to FILENAME");
        writeln("  -c|--clear\t\t\tClear the local database");
        writeln("  -d|--database [FILENAME]\tLoad data from FILENAME");
        writeln("");
    }

    /**
     * Print message with cat and information about saved password
     * Params:
     *     data = Array with the websites data
     * Throws:
     *     DatabaseException if data is incorrect
     */
    public static void printSave(immutable string [] data) @safe {
        enforce!DatabaseException(data.length == 3, "Incorrect website\'s data");
        writeln("\x1b[1m    ^~^  ,   Website : \x1b[0m", data[0]);
        writeln("\x1b[1m   ('Y') )   \x1b[0m");
        writeln("\x1b[1m   /   \\/    Login : \x1b[0m", data[1]);
        writeln("\x1b[1m  (\\|||/)    Password : \x1b[0m", data[2]);
        writeln("");
    }

    /**
     * Print current app's version
     */
    public static void printVersion() @safe {
        writeln(PACKAGE_NAME, " : ", MAJOR_VERSION, '.', MINOR_VERSION, '.', BUILD_VERSION);
    }

    /**
     * Print error message (With red indicator)
     * Params:
     *     error_msg = Error message for displaing
     */
    public static void printError(immutable string error_msg) @safe {
        writeln("\x1b[1;31mError : \x1b[0m", error_msg);
    }

    /**
     * Print warning message (With yellow indicator)
     * Params:
     *     warning = Warning message for displaing
     */
    public static void printWarning(immutable string warning) @safe { writeln("\x1b[1;33mWarning : \x1b[0m", warning); }

    /**
     * Print message (With green indicator)
     * Params:
     *     message = Message for displaing
     */
    public static void printMessage(immutable string message) @safe { writeln("\x1b[1;32mMessage : \x1b[0m", message); }

    /**
     * Get user's choice = to!ulong(user_input); (Show password, add password, exit)
     * Params:
     *     websites = Websites array for displaing
     * Returns:
     *     String with user's choice = to!ulong(user_input); ("" for exit and "\n\n" for user creating)
     */
    public static string getInput(immutable string [] websites) @trusted {
        while (true) {
            ulong counter = 0;
            foreach(i; websites) {
                writeln("\x1b[1m", counter + 1, ". \x1b[0m", i);
                counter++;
            }
            writeln("\x1b[1m", counter + 1, ". \x1b[0m", "Add new password");
            writeln("\x1b[1m", counter + 2, ". \x1b[0m", "Exit");
            counter += 2;

            try {
                write("Make your choice : ");
                string user_input = readln();
                user_input = user_input.replace("\r", "");
                user_input = user_input.replace("\n", "");

                writeln("");

                immutable ulong choice = to!ulong(user_input);
                if (choice > counter || choice == 0) {
                    Cli.printError("Incorrect input");
                    continue;
                }

                if (choice == counter) return "";
                else if (choice == counter - 1) return "\n\n";
                else return websites[choice - 1];
            } catch (Exception e) {
                Cli.printError(e.msg);
                continue;
            }
        }
    }


    /**
     * Get website's data from stdin
     * Returns:
     *     Array with website's data (name, login and password)
     */
    public static string [] inputWebsite() @trusted {
        string [] website = new string[3];

        write("Enter the website\'s name : ");
        website[0] = readln();
        write("Enter the website\'s login : ");
        website[1] = readln();
        write("Enter the website\'s password : ");
        website[2] = readln();

        for (ulong i = 0; i < 3; i++) {
            website[i] = website[i].replace("\r", "");
            website[i] = website[i].replace("\n", "");
        }

        return website;
    }
}

