module notebook;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.Image;
import Gtk.Label;
import Gtk.Notebook;
import Gtk.Types : Orientation;

import example;

class NotebookExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new NotebookWindow(app); }
}

class NotebookWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Simple Notebook Example");

        auto notebook = new Notebook();
        setChild(notebook);

        auto page1 = new Box(Orientation.Vertical, 0);
        page1.append(new Label("Default Page!"));
        notebook.appendPage(page1, new Label("Plain Title"));

        auto page2 = new Box(Orientation.Vertical, 0);
        page2.append(new Label("A page with an image for a Title."));
        notebook.appendPage(page2, Image.newFromIconName("help-about"));
    }
}
