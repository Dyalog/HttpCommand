**`HttpCommand`** attempts to group the values for the return code, `rc`, based on the circumstance of the event or error. There are three generic groups with reserved ranges for values of `rc`. Values of `rc` not listed in this document are reserved for possible future use.

|Group Type|Values|Description|
|-|-|-|
|Pre-request|`¯1-¯99`|Errors before HttpCommand can attempt to send the request.|
|Request|`>0`|Errors signalled by Conga when sending the request and receiving the response.|
|Post-request|`¯100-¯199`|Errors or events that occur either during the receipt of data that are not Conga-related or in post processing the response|. 
