module notebook;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.image;
import gtk.label;
import gtk.notebook;
import gtk.types : Orientation;

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
