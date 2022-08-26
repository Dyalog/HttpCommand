## Version 5.0

* The major version bump from 4 to 5 was due to:
    * swapping the meaning for the `Timeout` and `WaitTime` settings. Previously `Timeout` was used to indicate how long Conga's `Wait` function would wait for a response and `WaitTime` was how long `HttpCommand` would wait for a complete response before timing out.
    * return codes and messages were normalized 
* Added new `Auth` and `AuthType` settings to more easily support token-based authentication.
* Removed half-implemented support for streaming
* Added `GetHeader` function to result namespace
* More complete setting checking
* Better handling of relative redirections
* New documentation