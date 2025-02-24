module grid;

import gtk.application;
import gtk.application_window;
import gtk.button;
import gtk.grid;
import gtk.types : PositionType;

import example;

class GridExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new GridWindow(app); }
}

class GridWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Grid Example");

        auto button1 = Button.newWithLabel("Button 1");
        auto button2 = Button.newWithLabel("Button 2");
        auto button3 = Button.newWithLabel("Button 3");
        auto button4 = Button.newWithLabel("Button 4");
        auto button5 = Button.newWithLabel("Button 5");
        auto button6 = Button.newWithLabel("Button 6");

        auto grid = new Grid;

        grid.attach(button1, 0, 0, 1, 1);
        grid.attach(button2, 1, 0, 2, 1);
        grid.attachNextTo(button3, button1, PositionType.Bottom, 1, 2);
        grid.attachNextTo(button4, button3, PositionType.Right, 2, 1);
        grid.attach(button5, 1, 2, 1, 1);
        grid.attachNextTo(button6, button5, PositionType.Right, 1, 1);

        setChild(grid);
    }
}
