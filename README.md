# xcode server bot set up

## Pre-integration script
```
#!/bin/bash -l
export PATH=$PATH:/usr/local/bin

cd TnC

carthage bootstrap --platform ios
```
