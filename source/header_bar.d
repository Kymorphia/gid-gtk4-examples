module header_bar;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Button;
import Gtk.HeaderBar;

import example;

class HeaderBarExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new HeaderBarWindow(app); }
}

class HeaderBarWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setDefaultSize(400, -1);
        setTitle("HeaderBar Example");

        auto headerBar = new HeaderBar;
        setTitlebar(headerBar);

        auto button = Button.newWithLabel("Button");
        headerBar.packStart(button);

        auto iconButton = new Button;
        iconButton.setIconName("open-menu-symbolic");
        headerBar.packEnd(iconButton);
    }
}
