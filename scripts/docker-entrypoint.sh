#!/bin/bash

set -e

env

#### ---- Make sure to provide Non-root user for launching Docker ----
#### ---- Default, we use base images's "developer"               ----
NON_ROOT_USER=${NON_ROOT_USER:-"developer"}


#### -----------------------------------------------------------------------
#### 2.A) As Root User -- Choose this or 2.B --####
#### ---- Use this when running Root user ---- ####
/bin/bash -c "$@"

#### 2.B) As Non-Root User -- Choose this or 2.A  ---- #### 
#### ---- Use this when running Non-Root user ---- ####
#### ---- Use gosu (or su-exec) to drop to a non-root user
#exec gosu ${NON_ROOT_USER} "$@"
#### -----------------------------------------------------------------------

tail -f /dev/null
