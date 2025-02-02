module example;

import Gtk.Application;
import Gtk.ApplicationWindow;

/// Example categories which are branches in the example tree
enum ExampleCategory
{
  Default, /// Default is the root
  Containers, /// Layout containers
  Controls, /// Control widgets
  Display, /// Display widgets
}

abstract class Example
{
  @property ExampleCategory category();
  ApplicationWindow createWindow(Application app);
}
