module app;

import Gio.Types : ApplicationFlags;
import Gio.ApplicationGio;
import Gio.ApplicationCommandLine;
import Gio.MenuModel;
import Gio.SimpleAction;
import GLib.Types : OptionArg, OptionFlags;
import GLib.VariantG;
import GObject.ObjectG;
import GObject.ParamSpec;
import Gtk.AboutDialog;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Builder;
import Gtk.Label;

import app_tree;

import std.stdio : writeln;

enum MENU_XML =
`<?xml version="1.0" encoding="UTF-8"?>
<interface>
<menu id="menubar">
    <submenu>
        <attribute name="label" translatable="yes">File</attribute>
        <section>
            <item>
                <attribute name="action">win.maximize</attribute>
                <attribute name="label" translatable="yes">Maximize</attribute>
            </item>
        </section>
        <section>
            <item>
                <attribute name="action">app.about</attribute>
                <attribute name="label" translatable="yes">_About</attribute>
            </item>
            <item>
                <attribute name="action">app.quit</attribute>
                <attribute name="label" translatable="yes">_Quit</attribute>
                <attribute name="accel">&lt;Primary&gt;q</attribute>
            </item>
        </section>
    </submenu>
</menu>
</interface>
`;

class AppWindow : ApplicationWindow
{
    Label label;

    this(Application app)
    {
        super(app);
        setTitle("Main Window");
        setDefaultSize(600, 800);
        setShowMenubar = true;

        // Maximize action
        auto boolVariant = new VariantG(false);
        auto maxAction = SimpleAction.newStateful("maximize", null, boolVariant);
        maxAction.connectChangeState(&onMaximizeToggle);
        addAction(maxAction);

        // Keep maximize action in sync with window state
        connectNotify("maximized", (ParamSpec pspec, ObjectG obj) {
            maxAction.setState(new VariantG(isMaximized));
        });

        auto appTree = new AppTree(app);
        setChild(appTree);
    }

    void onMaximizeToggle(VariantG value, SimpleAction action)
    {
        action.setState(value);
        if (value.get!bool)
            maximize;
        else
            unmaximize;
    }
}

class ExampleApp : Application
{
    AppWindow window;

    this()
    {
        super("org.example.App", ApplicationFlags.HandlesCommandLine);
        addMainOption("test", 't', cast(OptionFlags)0, OptionArg.None, "Command line test", null);
        connectStartup(&onStartup);
        connectActivate(&onActivate);
        connectCommandLine(&onCommandLine);
    }

    void onStartup(ApplicationGio app)
    {
        auto aboutAction = new SimpleAction("about", null);
        aboutAction.connectActivate(&onAbout);
        addAction(aboutAction);

        auto quitAction = new SimpleAction("quit", null);
        quitAction.connectActivate(&onQuit);
        addAction(quitAction);

        auto builder = Builder.newFromString(MENU_XML);
        setMenubar(cast(MenuModel)builder.getObject("menubar"));
    }

    void onActivate(ApplicationGio app)
    {
        if (!window)
            window = new AppWindow(this);

        window.present();
    }

    int onCommandLine(ApplicationCommandLine commandLine, ApplicationGio app)
    {
        auto options = commandLine.getOptionsDict();

        if (options.contains("test"))
            writeln("Test argument received");

        activate;
        return 0;
    }

    void onAbout(VariantG parameter, SimpleAction action)
    {
        auto aboutDialog = new AboutDialog();
        aboutDialog.present;
    }

    void onQuit(VariantG parameter, SimpleAction action)
    {
        quit;
    }
}

void main(string[] args)
{
    auto app = new ExampleApp;
    app.run(args);
}
