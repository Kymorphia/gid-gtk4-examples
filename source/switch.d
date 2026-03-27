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

        auto hbox = Box.builder.orientation(Orientation.Horizontal).spacing(6).homogeneous(true).marginTop(24)
            .marginBottom(24).build;
        setChild(hbox);

        auto switch1 = Switch.builder.active(false).halign(Align.Center).build;
        switch1.connectNotify("active", &onSwitchActivated); // Connect to the notify signal for 'active' property
        hbox.append(switch1);

        auto switch2 = Switch.builder.active(true).halign(Align.Center).build;
        switch2.connectNotify("active", &onSwitchActivated);
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
