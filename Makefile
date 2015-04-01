WORKSPACE = Example/Example.xcworkspace
SCHEME = Example

clean:
	set -o pipefail && xctool -workspace $(WORKSPACE) -scheme $(SCHEME) clean

build:
	set -o pipefail && xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -sdk iphonesimulator build

test:
	set -o pipefail && xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -sdk iphonesimulator test
