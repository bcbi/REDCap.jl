```@meta
CurrentModule = REDCap
```

# Internals

These are not part of the public API. Every public function is a single call into this
machinery: the method spec table (`METHOD_SPECS`) describes each function, the request
builder turns a client, a spec and the user's arguments into a `REDCapRequest` without any
I/O, a transport sends it, and the response handler converts the result to the declared
return type.

```@autodocs
Modules = [REDCap]
Public = false
```
