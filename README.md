# RedCap

[![Build Status](https://travis-ci.org/FLCN17/REDCap.jl.svg?branch=master)](https://travis-ci.org/FLCN17/REDCap.jl)

[![Coverage Status](https://coveralls.io/repos/FLCN17/REDCap.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/FLCN17/REDCap.jl?branch=master)

[![codecov.io](http://codecov.io/github/FLCN17/REDCap.jl/coverage.svg?branch=master)](http://codecov.io/github/FLCN17/REDCap.jl?branch=master)



## Overview

A Julia frontend for the REDCap API. REDCap.jl supports both importing and exporting records, as well as deletion from the REDCap Database. It also includes functions for surveys and report generation. 

Available under the MIT license.

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://bcbi.github.io/REDCap.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)


## Getting Started 

### Prerequisites *

(What things you need to install the software and how to install them
Give a list with links and how to install using code snippets.)

```
brew install ...
npm install
conda install ...
```

### Installing *

(A step by step on how to install the package.

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo)


## Tests 

Tests can be run using the Julia package manager
```bash
Pkg.test("REDCap")
```

Due to the nature of the API, the API-Key and URL must be set in the users `.juliarc` file:
```bash
ENV["REDCAP_SUPER_API"] = "<super-key>"
ENV["REDCAP_API"] = "<key>"
ENV["REDCAP_URL"] = "<url>"
```
If a super-key is not provided, project creation will not be tested.

## Deployment *

Add additional notes about how to deploy this on a local machine and in a cloud provider.


## Contributing *

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Release History
- 0.1


## Authors

List authors and affiliation.

