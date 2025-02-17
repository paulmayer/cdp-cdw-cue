package extensions

import (
	core "k8s.io/api/core/v1"
)


#V1AlphaCatalogdPatch: {
	apiVersion: "v1alpha"
	kind:       "CatalogdPatch"
	spec:       core.#PodSpec
}
