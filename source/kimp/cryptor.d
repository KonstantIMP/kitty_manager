// Define module
module kimp.cryptor;

// Import exception and coversation modules
import std.exception, std.conv;

/**
 * Excepion class for Cryptor
 * See_Also: Cryptor, Exception
 */
class CryptException : Exception {
    /**
     * Default constructor for Cryptor
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
 * Class for crypting and decrypting passwords
 */
class Cryptor {
    /**
     * Crypt message by XOR letters from message and letters from key
     * Params:
     *     msg = Message for crypting
     *     key = Key for crypting
     * Throws:
     *     CryptException if key is wrong
     */
    public static string xorCrypt(immutable string msg, immutable string key) @safe {
        enforce!CryptException(key.length != 0, "Key is wrong (length mustn\'t be 0)");
        string result = "";

        for (ulong i = 0; i < msg.length; i++) {
            result ~= to!string(msg[i] ^ key[i % key.length]);
        }

        return result;
    }
}
