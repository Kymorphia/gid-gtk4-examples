module button;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.Button;
import Gtk.Types : Orientation;
import std.stdio : writeln;

import example;

class ButtonExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new ButtonWindow(app); }
}

class ButtonWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Button Demo");

        Box hbox = new Box(Orientation.Horizontal, 6);
        setChild(hbox);

        Button clickMeButton = Button.newWithLabel("Click Me");
        clickMeButton.connectClicked((Button button) { writeln("[Click me] button was clicked"); }); // Use a lambda callback
        hbox.append(clickMeButton);

        Button openButton = Button.newWithMnemonic("_Open");
        openButton.connectClicked(&onOpenClicked); // Use a callback function
        hbox.append(openButton);

        void onCloseClicked(Button button)
        {
            writeln("Closing window");
            close();
        }

        Button closeButton = Button.newWithMnemonic("_Close");
        closeButton.connectClicked(&onCloseClicked); // Use an embedded callback delegate
        hbox.append(closeButton);
    }
}

void onOpenClicked(Button button)
{
  writeln("[Open] button was clicked");
}
