module check_button;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.check_button;
import gtk.types : Orientation;
import std.stdio : writeln;

import example;

class CheckButtonExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new CheckButtonWindow(app); }
}

class CheckButtonWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("CheckButton Demo");

        Box box = new Box(Orientation.Horizontal, 6);
        setChild(box);

        CheckButton check = CheckButton.newWithLabel("Checkbox");
        check.connectToggled(&onCheckToggled);
        box.append(check);

        CheckButton radio1 = new CheckButtonWithLabelAndName("Radio 1", "1");
        radio1.connectToggled(&onRadioToggled);
        box.append(radio1);

        CheckButton radio2 = new CheckButtonWithLabelAndName("Radio 2", "2");
        radio2.setGroup(radio1); // Link this radio button to the group of radio1
        radio2.connectToggled(&onRadioToggled);
        box.append(radio2);

        CheckButton radio3 = new CheckButtonWithLabelAndName("_Radio 3", "3");
        radio3.setGroup(radio1);
        radio3.connectToggled(&onRadioToggled);
        box.append(radio3);
    }

    void onCheckToggled(CheckButton check)
    {
        string state = check.getActive() ? "on" : "off";
        writeln("Checkbox was turned ", state);
    }

    void onRadioToggled(CheckButton radio)
    {
        string state = radio.getActive() ? "on" : "off";
        writeln("Radio ", (cast(CheckButtonWithLabelAndName)radio).name, " was turned ", state);
    }
}

class CheckButtonWithLabelAndName : CheckButton
{
    this(string label, string name)
    {
        setLabel(label);
        setUseUnderline(true);
        this.name = name;
    }

    string name;
}