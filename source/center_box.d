module center_box;

import gtk.application;
import gtk.application_window;
import gtk.button;
import gtk.center_box;
import gtk.label;

import example;

class CenterBoxExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new CenterBoxWindow(app); }
}

class CenterBoxWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setDefaultSize(400, -1);
        setTitle("CenterBox Example");

        auto box = new CenterBox;
        setChild(box);

        auto button1 = Button.newWithLabel("Start");
        box.setStartWidget(button1);

        auto label = new Label("Center");
        box.setCenterWidget(label);

        auto button2 = Button.newWithLabel("End");
        box.setEndWidget(button2);
    }
}
