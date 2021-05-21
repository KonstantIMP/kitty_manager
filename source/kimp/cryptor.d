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
        string result = "";// result.length = msg.length;

        for (ulong i = 0; i < msg.length; i++) {
            result ~= to!ubyte(msg[i]) ^ to!ubyte(key[i % key.length]);
        }

        return result;
    }

    /// Unit tests for xorCrypt
    @safe unittest {
        assert(xorCrypt("abcd", "abcd") == "\0\0\0\0");
        assert(xorCrypt("Hello", "w") == [0x3f, 0x12, 0x1b, 0x1b, 0x18]);
        assert(xorCrypt(xorCrypt("Message", "key"), "key") == to!string("Message"));
    }

    /**
     * Decrypt message by XOR letters from message and letters from key
     * Params:
     *     msg = Message for decrypting
     *     key = Key for decrypting
     * Throws:
     *     CryptException if key is wrong
     */
    alias xorDecrypt=xorCrypt;
}
