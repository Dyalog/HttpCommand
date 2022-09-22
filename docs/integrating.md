### Considerations

Two aspects that need to be considered when integrating `HttpCommand` into your application.

* Are there other components in your application that also use Conga?
* How will your application be deployed? 

### Use of Conga
If your application has other components that also use Conga, it's advisable that each component have its own Conga "root" created by `Conga.Init`. This requires the `Conga` namespace from the `conga` workspace. The recommended setup is:

* Copy the `Conga` namespace into your workspace. For this example, we will assume you've copied `Conga` into the root (`#`) namespace.
* Explicitly point `HttpCommand` at this `Conga` namespace by setting `HttpCommand.CongaRef←#.Conga` (or wherever you've copied `Conga`).
* All other Conga-using components should be similarly pointed at this `Conga` namespace.

When `HttpCommand` is initialized it will create a root named `'HttpCommand'` when `Conga.Init` is called. Your other components will create their own Conga roots when they also call `Conga.Init`. This will ensure that the Conga shared libraries are loaded only once.

### Deployment
In addition to the presence of other Conga-using components in your application, you need to consider how your application is deployed.  
#### Dyalog Installation Folder is Available
If the Dyalog installation folder is available, and there are no other components that use Conga, you can use `HttpCommand` without any additional configuration. `HttpCommand` will copy the `Conga` namespace from the `conga` workspace in the Dyalog installation and find the shared libraries in the Dyalog APL installation folder.

#### Dyalog Installation Folder is Not Available
If the Dyalog installation folder is not available, for instance in the case of a runtime application, or a bound or stand-alone executable, then you will need to have a copy of the `Conga` namespace in your workspace and either put the Conga shared libraries in the same folder as your executuable or set `CongaPath` to the location of the shared libraries. 