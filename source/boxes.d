module boxes;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.button;
import gtk.types : Orientation;
import std.stdio : writeln;

import example;

class BoxesExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new BoxesWindow(app); }
}

class BoxesWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);

        auto box = new Box(Orientation.Horizontal, 6);
        setChild(box);

        auto button1 = Button.newWithLabel("Hello");
        button1.connectClicked(() { writeln("Hello"); });
        box.append(button1);

        auto button2 = Button.newWithLabel("Goodbye");
        button2.setHexpand(true);
        button2.connectClicked(() { writeln("Goodbye"); });
        box.append(button2);
    }
}
