## Sugar

Sugar is a cross-platform compatibility base library for Oxygene, to be used with all three platform flavors of the Oxygene language — Echoes, Cooper and Nougat — to provide a combo API to frequently used base classes (such as list, dictionaries, strings, etc) on all three environments.

This will be achieved thru mapped classes that "translate" the framework-provided classes (such as java.util.Dictionary, System.Collections.Generic.Dictionary<T, U> or NSDictionary) to a shared API, and extension methods that will add common methods and operations on simple objects such as strings and integers.

The goal is the with Sugar a lot of _low-level_ code that uses the Oxygene language and these common base classes can be shared across platforms.

The goal is *not* to provide cross-platform shared libraries for higher-level platform features such as UI or system access.