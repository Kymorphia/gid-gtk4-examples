module switch_;

import gobject.object;
import gobject.param_spec;
import gtk.adjustment;
import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.check_button;
import gtk.switch_;
import gtk.types : Align, Orientation;
import std.stdio : writeln;

import example;

class SwitchExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new SwitchWindow(app); }
}

class SwitchWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Switch Demo");

        Box hbox = new Box(Orientation.Horizontal, 6);
        hbox.setHomogeneous(true);
        hbox.setMarginTop(24);
        hbox.setMarginBottom(24);
        setChild(hbox);

        Switch switch1 = new Switch;
        switch1.connectNotify("active", &onSwitchActivated); // Connect to the notify signal for 'active' property
        switch1.setActive(false);
        switch1.setHalign(Align.Center);
        hbox.append(switch1);

        Switch switch2 = new Switch;
        switch2.connectNotify("active", &onSwitchActivated);
        switch2.setActive(true);
        switch2.setHalign(Align.Center);
        hbox.append(switch2);
    }

    void onSwitchActivated(ParamSpec pspec, ObjectWrap obj)
    {
        if (auto switchObj = cast(Switch)obj)
        {
            string state = switchObj.getActive() ? "on" : "off";
            writeln("Switch was turned ", state);
        }
    }
}
