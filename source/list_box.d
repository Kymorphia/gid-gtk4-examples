module list_box;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.check_button;
import gtk.label;
import gtk.list_box;
import gtk.list_box_row;
import gtk.switch_;
import gtk.types : Align, Orientation, SelectionMode;

import example;

import std.stdio : writeln;
import std.string : split, toLower;

class ListBoxExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new ListBoxWindow(app); }
}

class ListBoxWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setDefaultSize(400, -1);
        setTitle("ListBox Demo");

        auto boxOuter = new Box(Orientation.Vertical, 24);
        boxOuter.setMarginStart = 24;
        boxOuter.setMarginEnd = 24;
        boxOuter.setMarginTop = 24;
        boxOuter.setMarginBottom = 24;
        setChild(boxOuter);

        // First ListBox
        auto listbox = new ListBox;
        listbox.setSelectionMode(SelectionMode.None);
        listbox.setShowSeparators(true);
        boxOuter.append(listbox);

        // First ListBox Row
        auto row = new ListBoxRow;
        auto hbox = new Box(Orientation.Horizontal, 24);
        row.setChild(hbox);
        auto vbox = new Box(Orientation.Vertical, 0);
        hbox.append(vbox);
        auto label1 = new Label("Automatic Date & Time");
        label1.setXalign(0);
        auto label2 = new Label("Requires internet access");
        label2.setXalign(0);
        vbox.append(label1);
        vbox.append(label2);

        auto sw = new Switch;
        sw.setHexpand(true);
        sw.setHalign(Align.End);
        sw.setValign(Align.Center);
        hbox.append(sw);

        listbox.append(row);

        // Second ListBox Row
        hbox = new Box(Orientation.Horizontal, 24);
        auto label = new Label("Enable Automatic Update");
        label.setXalign(0);
        auto check = new CheckButton;
        check.setHexpand(true);
        check.setHalign(Align.End);
        hbox.append(label);
        hbox.append(check);
        listbox.append(hbox);

        // Second ListBox
        auto listbox2 = new ListBox;
        boxOuter.append(listbox2);
        string[] items = "This is a sorted ListBox Fail".split();

        // Populate the list
        foreach (item; items)
            listbox2.append(new ListBoxRowWithData(item));

        // Set sorting and filter functions
        listbox2.setSortFunc(&sortFunc);
        listbox2.setFilterFunc(&filterFunc);

        // Connect to "row-activated" signal
        listbox2.connectRowActivated(&onRowActivated);
    }

    int sortFunc(ListBoxRow row1, ListBoxRow row2)
    {
        auto data1 = (cast(ListBoxRowWithData)row1).data.toLower();
        auto data2 = (cast(ListBoxRowWithData)row2).data.toLower();
        return (data1 > data2) ? 1 : (data1 < data2) ? -1 : 0;
    }

    bool filterFunc(ListBoxRow row)
    {
        auto data = (cast(ListBoxRowWithData)row).data;
        return data != "Fail";
    }

    void onRowActivated(ListBoxRow row, ListBox listbox)
    {
        writeln((cast(ListBoxRowWithData)row).data);
    }
}

class ListBoxRowWithData : ListBoxRow
{
    string data;

    this(string data)
    {
        super();
        this.data = data;
        setChild(new Label(data));
    }
}
