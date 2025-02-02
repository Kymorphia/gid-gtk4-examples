module boxes;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.Button;
import Gtk.Types : Orientation;
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
        button1.connectClicked(&onButton1Clicked);
        box.append(button1);

        auto button2 = Button.newWithLabel("Goodbye");
        button2.setHexpand(true);
        button2.connectClicked(&onButton2Clicked);
        box.append(button2);
    }

    void onButton1Clicked(Button button)
    {
        writeln("Hello");
    }

    void onButton2Clicked(Button button)
    {
        writeln("Goodbye");
    }
}
