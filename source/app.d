// Import kimp modules
import kimp.database, kimp.cli;
// Import getopt, exception and file modules
import std.getopt, std.file, std.exception;

/**
 * The app start point
 * Print messages, get data and tell with user
 * Params:
 *     args = Command line arguments (Read more "kitty_m -h")
 * Returns:
 *     0 if everything is OK
 */
int main(string [] args) {
	// Hello user
	Cli.printHello();

	// Variables for getopt
	bool h = false, v = false, c = false;
	string u = "", p = "", b = "", d = "";

	// Get CL options
	getopt(args, "h|help", &h, "v|version", &v, "b|backup", &b,
		"c|clear", &c, "u|user", &u, "p|passwd", &p, "d|database", &d);

	// Check Database
	if (d == "") d = "kitty.db";
	// Check help
	if (h) {
		Cli.printHelp();
		return 0;
	}
	// Check version
	if (v) {
		Cli.printVersion();
		return 0;
	}
	// Checl clear
	if (c) {
		if (exists(d) == true && isFile(d) == true) {
			remove(d);
			return 0;
		}
		else {
			Cli.printError("Cannot clear the database.");
			return -1;
		}
	}

	return 0;
}
