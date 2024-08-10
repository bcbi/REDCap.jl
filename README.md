# RedCap

<p>
<a href="https://travis-ci.org/bcbi/REDCap.jl/branches"><img alt="Travis build status" src="https://travis-ci.org/bcbi/REDCap.jl.svg?branch=master"></a>
<a href="http://codecov.io/github/bcbi/REDCap.jl?branch=master"><img src="http://codecov.io/github/bcbi/REDCap.jl/coverage.svg?branch=master"></a>
</p>

## Overview

A Julia frontend for the REDCap API. REDCap.jl supports both importing and exporting records, as well as deletion from the REDCap Database. It also includes functions for surveys and report generation. 

Available under the MIT license.

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://bcbi.github.io/REDCap.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)


## Getting Started 


### Installing

Julia can be found using the standard package manager, and installed like any other package.

```bash
add REDCap
```

## Tests 

Tests can be run using the Julia package manager
```bash
test REDCap
```

Your institution's REDCap URL and any tokens are read from Julia's environment variables.
You can make them avaiable to REDCap.jl by putting the following lines in [your local Julia startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file) (probably `~/.julia/config/startup.jl`):
```
ENV["REDCAP_API_SUPER_TOKEN"] = "ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234"
ENV["REDCAP_API_TOKEN"] = "ABCD1234ABCD1234ABCD1234ABCD1234"
ENV["REDCAP_API_URL"] = "http://example.com/redcap/api/"
```
If a super-key is not provided, project creation will not be tested. Otherwise, a project will be created, and verified.

### NOTE:
Testing must be performed on the users own REDCap environment. If you are unable to access your own REDCap environment, testing will also fail.
Projects are tested according to a rough template. Several tests may fail if your project deviates from this template such as record contents and users.

## Release History
- 1.0 - Initial Release - compatible with Julia 1.0 and REDCap 8.1.0

## Acknowledgements
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Team.

