PROJECT_DIR = Example
WORKSPACE = ${PROJECT_DIR}/Example.xcworkspace
SCHEME = Example
.PHONY: docs

clean:
	set -o pipefail && xctool clean

build:
	set -o pipefail && xctool build

tests:
	set -o pipefail && xctool GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES test

docs:
	/usr/local/bin/appledoc \
		--project-name CocoaUPnP \
		--project-company "Arcam" \
		--company-id com.arcam \
		--output docs \
		--ignore Example/Pods \
		--ignore "*.m" \
		--index-desc "README.md" \
		CocoaUPnP
