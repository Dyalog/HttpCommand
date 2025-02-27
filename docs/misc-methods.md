This section describes `HttpCommand` shared methods that don't conveniently fit into other categories.
### `Version` 
Returns `HttpCommand` version information.

|--|--|
|Syntax|`r←HttpCommand.Version`|
|Result|A 3-element vector of:<ul><li>`'HttpCommand'`</li><li>The version number</li><li>The version date</li>|
|Example|<pre style="font-family:APL;">      HttpCommand.Version<br/> HttpCommand  5.0.2  2022-08-03</pre>|


### `Documentation` 
Returns a link to the documentation for `HttpCommand` that you can click on to navigate to this documentation.

|--|--|
|Syntax|`r←HttpCommand.Documentation`|
|Example|<pre style="font-family:APL;">      HttpCommand.Documentation<br/>See https://dyalog.github.io/HttpCommand/</pre>|


### `Upgrade` 
`Upgrade` checks GitHub for a newer version of `HttpCommand` and if one is found it will be `⎕FIX`ed in the workspace.

`Upgrade` will not work on Classic interpreters. To manually upgrade `HttpCommand`:

* Open a browser to [https://www.github.com/Dyalog/HttpCommand/releases/latest](https://www.github.com/Dyalog/HttpCommand/releases/latest)
* Click on the `HttpCommand.dyalog` file in the list of assets for the release.  This will download the file.
* From APL, do `2 ⎕FIX 'filename'` where filename is the full pathname of the downloaded file. 

Note: `Upgrade` will only update the in-workspace copy of `HttpCommand` and will not update the version of `HttpCommand` found in the Dyalog installation folder. The installed version of `HttpCommand` is upgraded when updates to Dyalog APL are installed.

|--|--|
|Syntax|`r←HttpCommand.Upgrade`|
|`r`|a 2-element vector of:<ul><li>the return code which is `1` if `HttpCommand` was upgraded to a newer version, `0` if `HttpCommand` on GitHub is not newer than the current version, or `¯1` if there was an error `⎕FIX`ing `HttpCommand` from GitHub.</li><li>character vector message describing the result</li></ul>|
|Example|<pre style="font-family:APL;">      HttpCommand.Upgrade<br/> 0  Already using the most current version: HttpCommand 5.0.2 2022-08-03</pre>|
