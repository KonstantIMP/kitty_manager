// Import kimp modules
import kimp.database, kimp.cli;

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

	// Create database
	//auto d = new DatabaseHelper();

	return 0;
}
