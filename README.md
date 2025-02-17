Cloduera Data Warehouse with CUE
================================

This repository contains a small proof-of-concept for handling [Cloudera Public Cloud][CDP] virtual
warehouse definitions (together with extension configuration) using [CUE][CUE].

This repo contains the following example cue schema:

```
package root

import (
	"github.com/paulmayer/cdp-cdw-cue/api:v0_9_131"
    ext "github.com/paulmayer/cdp-cdw-cue/extensions"
)

#VirtualWarehouse: {
	apiVersion: "v1alpha"
	kind:       "VirtualWarehouse"
    n=name!:      string

	spec: v0_9_131.#CreateVwRequest & {
        name: n
    }

	extensions: [...ext.#Extension]
}

```

where the `CreateVwRequest` schema is directly taken from [CDP API docs][CDPAPI] and
extension definitions are managed in the present cue module.


How to use
----------

The repository contains a `Makefile` which retrieves data warehouse API docs from [CDP API docs][CDPAPI], converting
swagger definitions to OAPI 3.0 and subsequently importing them to cue.

Run 

```
make all
```

to import the relevant cue schema and vet the example minimal vw definition in `examples/example.yaml`:

```
cue vet examples/example.yaml examples/root.cue -d "#VirtualWarehouse"
```

To export the virtual warehouse definition in yaml, run:

```
cue export examples/example.yaml examples/root.cue -d "#VirtualWarehouse" --out yaml
```

References
----------

[CDP]: https://docs.cloudera.com/cdp-public-cloud/cloud/overview/topics/cdp-public-cloud.html
[CUE]: https://cuelang.org/
[CDPAPI]: https://github.com/cloudera/cdp-dev-docs/tree/master/api-docs/swagger