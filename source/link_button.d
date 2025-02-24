module link_button;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.link_button;
import gtk.types : Orientation;
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
