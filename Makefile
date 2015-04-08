PROJECT_DIR = Example
WORKSPACE = ${PROJECT_DIR}/Example.xcworkspace
SCHEME = Example

clean:
	set -o pipefail && xctool -workspace $(WORKSPACE) -scheme $(SCHEME) clean

build:
	set -o pipefail && xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -sdk iphonesimulator build

test:
	set -o pipefail && xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -sdk iphonesimulator test

docs:
	/usr/local/bin/appledoc \
		--project-name CocoaUPnP \
		--project-company "Arcam" \
		--company-id com.arcam \
		--output docs \
		--ignore Example/Pods \
		--ignore "*.m" \
		--index-desc "README.md" \
		.
