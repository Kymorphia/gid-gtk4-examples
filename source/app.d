module app;

import gio.types : ApplicationFlags;
import gio.application;
import gio.menu_model;
import gio.simple_action;
import glib.types : OptionArg, OptionFlags;
import glib.variant;
import gobject.object;
import gobject.param_spec;
import gtk.about_dialog;
import gtk.application;
import gtk.application_window;
import gtk.builder;
import gtk.label;

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

    this(gtk.application.Application app)
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

class ExampleApp : gtk.application.Application
{
    AppWindow window;

    this()
    {
        super("org.example.App", ApplicationFlags.DefaultFlags);
        connectStartup(&onStartup);
        connectActivate(&onActivate);
    }

    void onStartup(gio.application.Application app)
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

    void onActivate(gio.application.Application app)
    {
        if (!window)
            window = new AppWindow(this);

        window.present();
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
