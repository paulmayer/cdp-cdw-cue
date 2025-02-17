# CDP_API_VERSIONS
# collects a list of API document versions to be pulled from
# CDP_SWAGGER_SRC. 
CDP_API_VERSIONS ?= 0.9.131
CDP_SWAGGER_SRC ?= raw.githubusercontent.com/cloudera/cdp-dev-docs
CDP_SWAGGER_PATH ?= api-docs/swagger
SCHEMA_FILE_NAME ?= dw.yaml
OPENAPI_CONVERTER ?= converter.swagger.io/api/convert


api:
	mkdir -p api


assets/cloudera:
	mkdir -p assets/cloudera


assets/cloudera/%.yaml: assets/cloudera
	@API_VERSION=$(shell echo $(@) | cut -f 3 -d /); \
	API_VERSION=$${API_VERSION%%.yaml}; \
	curl -s "https://$(OPENAPI_CONVERTER)?url=https://$(CDP_SWAGGER_SRC)/cdp-api-$${API_VERSION}/$(CDP_SWAGGER_PATH)/$(SCHEMA_FILE_NAME)" \
		-H "Accept: application/yaml" \
		-o "$(@)"; \
	IDENTIFIED_API_VERSION=$$(yq -r '.info.version' $(@)); \
	[[ "$${IDENTIFIED_API_VERSION}" == "$${API_VERSION##"cdp-api-"}" ]] || \
		( \
			echo "Mismatch identified api version ($${IDENTIFIED_API_VERSION}) and expected api version ($${API_VERSION##"cdp-api-"}). Removing file $(@)"; \
			rm "$(@)"; \
			exit 101 ; \
		) ;


api/%.cue: assets/cloudera/%.yaml
	@API_VERSION=$(shell echo $(@) | cut -f 2 -d /); \
	API_VERSION=$$( echo "$${API_VERSION%%.cue}" | sed 's/\./_/g' ); \
	cue import -p "v$${API_VERSION}" $< -o $@


all: $(foreach version,$(CDP_API_VERSIONS),api/$(version).cue)


clean:
	rm -rf assets/cloudera
	rm -rf api


update: clean all


.PHONY: all .schema-%
.PRECIOUS: assets/cloudera/%.yaml api/%.cue