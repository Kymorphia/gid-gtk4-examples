module link_button;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.LinkButton;
import Gtk.Types : Orientation;
import std.stdio : writeln;

import example;

class LinkButtonExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new LinkButtonWindow(app); }
}

class LinkButtonWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("LinkButton Demo");

        auto btn = LinkButton.newWithLabel("https://www.gtk.org", "Visit GTK Homepage");
        setChild(btn);
    }
}
