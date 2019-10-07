# CIS Kubernetes Benchmark - InSpec Profile

## Description
This profile implements the [CIS Kubernetes 1.4.1 Benchmark](https://www.cisecurity.org/benchmark/kubernetes/).

## Attributes

To switch between the CIS profile levels the following attribute can be used:

  * `cis_level: 2`
    define which profile level to use, accepted values are `1` and `2`.

Refer to the [InSpec Profiles Reference](https://www.inspec.io/docs/reference/profiles/) for more information about Profile Attributes.

## Usage

This Compliance Profile requires [InSpec](https://github.com/chef/inspec) for execution:

```
$ git clone https://github.com/dev-sec/cis-kubernetes-benchmark
$ inspec exec cis-kubernetes-benchmark
```

You can also execute the profile directly from Github:

```
$ inspec exec https://github.com/dev-sec/cis-kubernetes-benchmark
```

Or execute specific controls instead of all:

```
$ inspec exec cis-kubernetes-benchmark --controls=cis-kubernetes-benchmark-1.1.2 cis-kubernetes-benchmark-1.3.5
```

Refer to the [InSpec CLI reference](https://www.inspec.io/docs/reference/cli) for more information.

## License and Author

* Author:: Kristian Vlaardingerbroek <kvlaardingerbroek@schubergphilis.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
