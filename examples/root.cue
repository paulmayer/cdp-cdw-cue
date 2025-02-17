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
