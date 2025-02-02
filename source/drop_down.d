module drop_down;

import GObject.ObjectG;
import GObject.ParamSpec;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.DropDown;
import Gtk.StringList;
import Gtk.StringObject;
import std.stdio : writeln;
import std.string : split;

import example;

class DropDownExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new DropDownWindow(app); }
}

class DropDownWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("DropDown Demo");

        auto strings = "This is a long list of words to populate the dropdown".split;
        DropDown dropdown = DropDown.newFromStrings(strings);
        dropdown.connectNotify("selected-item", &onStringSelected); // Connect to the notify signal for 'selected-item' property
        setChild(dropdown);
    }

    void onStringSelected(ParamSpec pspec, ObjectG dropdownObj)
    {
        if (auto dropdown = cast(DropDown)dropdownObj)
            if (auto selected = cast(StringObject)dropdown.getSelectedItem)
                writeln("Selected ", selected.getString);
    }
}
