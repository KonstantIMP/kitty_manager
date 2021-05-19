// Define kimp.cli module
module kimp.cli;

// Import stdio and defines
import std.stdio, kimp.defines;;

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
    }
}

