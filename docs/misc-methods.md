This section describes `HttpCommand` shared methods that don't conveniently fit into other categories.
### `Version` 
Returns `HttpCommand` version information.
<table>
<tr><td>Syntax</td>
<td><code>r←HttpCommand.Version</code></td><td> </tr>
<tr><td>Result</td>
<td>A 3-element vector of:<ul>
<li><code>'HttpCommand'</code></li>
<li>The version number</li>
<li>The version date</li>
</td></tr>
<tr><td>Example</td>
<td><code>      HttpCommand.Version</code><br/>
<code> HttpCommand  5.0.2  2022-08-03</code></td></tr>
</table>

### `Documentation` 
Returns a link to the documentation for `HttpCommand` that you can click on to navigate to this documentation.
<table>
<tr><td>Syntax</td>
<td><code>r←HttpCommand.Documentation</code></td><td> </td></tr>
<tr><td>Example</td>
<td><code>      HttpCommand.Documentation</code><br/>
<code>See <a href="https://dyalog.github.io/HttpCommand/">https://dyalog.github.io/HttpCommand/</a></code></td></tr>
</table>

### `Upgrade` 
`Upgrade` checks GitHub for a newer version of `HttpCommand` and if one is found it will be `⎕FIX`ed in the workspace.

`Upgrade` will not work on Classic interpreters. To manually upgrade `HttpCommand`:

* Open a browser to [https://www.github.com/Dyalog/HttpCommand/releases/latest](https://www.github.com/Dyalog/HttpCommand/releases/latest)
* Click on the `HttpCommand.dyalog` file in the list of assets for the release.  This will download the file.
* From APL, do `2 ⎕FIX 'filename'` where filename is the full pathname of the downloaded file. 

Note: `Upgrade` will only update the in-workspace copy of `HttpCommand` and will not update the version of `HttpCommand` found in the Dyalog installation folder. The installed version of <code>HttpCommand</code> is upgraded when updates to Dyalog APL are installed.<table>
<tr><td>Syntax</td>
<td><code>r←HttpCommand.Upgrade</code></td></tr>
<tr><td><code>r</code></td>
<td>a 2-element vector of<br/><ul><li>the return code which is <code>1</code> if <code>HttpCommand</code> was upgraded to a newer version, <code>0</code> if <code>HttpCommand</code> on GitHub is not newer than the current version, or <code>¯1</code> if there was an error <code>⎕FIX</code>ing <code>HttpCommand</code> from GitHub.
</li>
<li>character vector message describing the result</li>
</ul></td></tr>
<tr><td>Example</td>
<td><code>      HttpCommand.Upgrade</code><br/>
<code>
 0  Already using the most current version: HttpCommand 5.0.2 2022-08-03</code>
</td></tr>
</table>