# giD Gtk4 Examples

Here you will find an example application written using the D language and utilizing the [giD](https://github.com/Kymorphia/gid/) Gtk4 bindings.

Most of the examples were ported from these [Python PyGObject GTK4 Examples](https://pygobject.gnome.org/tutorials/gtk4.html).
Please consult that documentation for details on Gtk4 widgets which are relevant to each example.
The PyGObject Gtk4 API is fairly similar to the giD D binding and the example D code is intended to be used directly as a quickstart guide.
Each example has its own D source file and they are launched from within the example application by double clicking on them in the tree.

## Building on Linux

Install your favorite D compiler and run `dub build`.

## Building on Windows

Here are some instructions for installing MSYS2, LDC2, dub, and Gtk4 packages for building the Gtk4 Examples.
There are many other ways to configure a Windows D development environment, this is just one example.

* Go to https://www.msys2.org/, download the msys2 installer, and install it.
* Download the latest Visual C++ Redistributable X64 package at https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist and install it.
  * For example the https://aka.ms/vs/17/release/vc_redist.x64.exe package
* Run the MSYS2 UCRT64 shell
* Run the following command to install git, unzip, 7zip, and GTK4 libraries

```sh
pacman -S git unzip mingw-w64-ucrt-x86_64-7zip mingw-w64-ucrt-x86_64-gtk4
```

* Go to https://github.com/ldc-developers/ldc/releases and copy the link to the latest **windows-x64**
  archive and paste it in the shell after a `wget` command (SHIFT-INS). For example:

```sh
wget https://github.com/ldc-developers/ldc/releases/download/v1.40.0/ldc2-1.40.0-windows-x64.7z
```

* Extract the archive with the command (use the name of the archive you downloaded):

```sh
7z x ldc2-1.40.0-windows-x64.7z
```

* Add the bin directory of ldc2 to your path (change the directory name to match the version):

```sh
export PATH=$PATH:$(pwd)/ldc2-1.40.0-windows-x64/bin
```

* Go to https://github.com/dlang/dub/releases and copy the link to the latest **windows-x86_64**
  archive and paste it in the shell after a `wget` command (SHIFT-INS). For example:

```
wget https://github.com/dlang/dub/releases/download/v1.38.1/dub-v1.38.1-windows-x86_64.zip
```

* Create a bin directory, extract dub to it, and add it to the PATH,
  be sure to change the name of the dub archive to match the one you downloaded:

```sh
mkdir bin
cd bin
unzip ../dub-v1.38.1-windows-x86_64.zip
export PATH=$PATH:$(pwd)
cd ..
```

* Clone the gid-gtk4-examples repository
  `git clone https://github.com/Kymorphia/gid-gtk4-examples.git`
* Change to the gid-gtk4-examples directory and build it with dub.

```sh
cd gid-gtk4-examples
dub build
```
