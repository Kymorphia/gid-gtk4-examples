all: build

build:
	dub build --compiler=ldc2

clean:
	dub clean
	rm -f *.so gid-gtk4-examples
