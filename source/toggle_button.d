module toggle_button;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.ToggleButton;
import Gtk.Types : Orientation;
import std.stdio : writeln;

import example;

class ToggleButtonExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new ToggleButtonWindow(app); }
}

class ToggleButtonWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("ToggleButton Demo");

        Box hbox = new Box(Orientation.Horizontal, 6);
        setChild(hbox);

        ToggleButton button1 = ToggleButton.newWithLabel("Button 1");
        hbox.append(button1);

        ToggleButton button2 = ToggleButton.newWithMnemonic("_Button 2");
        button2.setActive(true);
        hbox.append(button2);

        void onButtonToggled(ToggleButton button)
        {
            string state = button.getActive() ? "on" : "off";
            writeln("Button ", (button == button1 ? "1" : "2"), " was turned ", state);
        }

        button1.connectToggled(&onButtonToggled);
        button2.connectToggled(&onButtonToggled);
    }
}
