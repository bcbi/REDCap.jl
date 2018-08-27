# RedCap

[![Build Status](https://travis-ci.org/bcbi/REDCap.jl.svg?branch=master)](https://travis-ci.org/bcbi/REDCap.jl)

<!---
[![Coverage Status](https://coveralls.io/repos/bcbi/REDCap.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/bcbi/REDCap.jl?branch=master)

[![codecov.io](http://codecov.io/github/bcbi/REDCap.jl/coverage.svg?branch=master)](http://codecov.io/github/bcbi/REDCap.jl?branch=master)
--->


## Overview

A Julia frontend for the REDCap API. REDCap.jl supports both importing and exporting records, as well as deletion from the REDCap Database. It also includes functions for surveys and report generation. 

Available under the MIT license.

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)
<!---
	#Re-enable once docs push right
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://bcbi.github.io/REDCap.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)
--->

## Getting Started 


### Installing

Julia can be found using the standard package manager.

```bash
add REDCap
```

## Tests 

Tests can be run using the Julia package manager
```bash
test REDCap
```

Due to the nature of the API, the API-Key and URL must be set in the users `.juliarc` file:
```bash
ENV["REDCAP_SUPER_API"] = "<super-key>"
ENV["REDCAP_API"] = "<key>"
ENV["REDCAP_URL"] = "<url>"
```
If a super-key is not provided, project creation will not be tested. Otherwise, a project will be created, and verified.

### NOTE:
Projects are tested according to a rough template. Several tests may fail if your project deviates from this template such as record contents and users.

## Deployment *

Add additional notes about how to deploy this on a local machine and in a cloud provider.


## Contributing *

Please read [CONTRIBUTING.md]() for details on our code of conduct, and the process for submitting pull requests to us.

## Release History *
- 0.1


## Authors *

List authors and affiliation.

