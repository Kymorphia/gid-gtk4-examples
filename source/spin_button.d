module spin_button;

import gtk.adjustment;
import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.check_button;
import gtk.spin_button;
import gtk.types : Orientation, SpinButtonUpdatePolicy;
import std.stdio : writeln;

import example;

class SpinButtonExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new SpinButtonWindow(app); }
}

class SpinButtonWindow : ApplicationWindow
{
    SpinButton spinbutton;

    this(Application app)
    {
        super(app);
        setTitle("SpinButton Demo");

        Box hbox = new Box(Orientation.Horizontal, 6);
        setChild(hbox);

        auto adjustment = new Adjustment(0, 0, 100, 1, 10, 0); // value, lower, upper, step_increment, page_increment, page_size
        spinbutton = new SpinButton(adjustment, 0, 0); // adjustment, climb_rate, digits
        spinbutton.connectValueChanged(&onValueChanged);
        hbox.append(spinbutton);

        CheckButton checkNumeric = CheckButton.newWithLabel("Numeric");
        checkNumeric.connectToggled(&onNumericToggled);
        hbox.append(checkNumeric);

        CheckButton checkIfValid = CheckButton.newWithLabel("If Valid");
        checkIfValid.connectToggled(&onIfValidToggled);
        hbox.append(checkIfValid);
    }

    void onValueChanged(SpinButton spinbutton)
    {
        writeln(spinbutton.getValueAsInt);
    }

    void onNumericToggled(CheckButton button)
    {
        spinbutton.setNumeric(button.getActive);
    }

    void onIfValidToggled(CheckButton button)
    {
        spinbutton.setUpdatePolicy(button.getActive ? SpinButtonUpdatePolicy.IfValid : SpinButtonUpdatePolicy.Always);
    }
}
