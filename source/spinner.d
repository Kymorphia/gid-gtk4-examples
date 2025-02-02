module spinner;

import GLib.Global : timeoutAdd;
import GLib.Source : Source;
import GLib.Types : PRIORITY_DEFAULT;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.Button;
import Gtk.Entry;
import Gtk.Label;
import Gtk.Spinner;
import Gtk.Types : Orientation;
import Gtk.Widget;

import std.conv : to;

import example;

class SpinnerExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Display; }
    override ApplicationWindow createWindow(Application app) { return new SpinnerWindow(app); }
}

class SpinnerWindow : ApplicationWindow
{
    Spinner spinner;
    Label label;
    Entry entry;
    Button buttonStart;
    Button buttonStop;
    uint timeoutId;
    int counter;

    this(Application app)
    {
        super(app);
        setTitle("Spinner Demo");

        Box mainBox = new Box(Orientation.Vertical, 6);
        setChild(mainBox);

        spinner = new Spinner;
        mainBox.append(spinner);

        label = new Label(cast(string)null);
        mainBox.append(label);

        entry = new Entry;
        entry.setText("10");
        mainBox.append(entry);

        buttonStart = Button.newWithLabel("Start timer");
        buttonStart.connectClicked(&onButtonStartClicked);
        mainBox.append(buttonStart);

        buttonStop = Button.newWithLabel("Stop timer");
        buttonStop.setSensitive(false);
        buttonStop.connectClicked(&onButtonStopClicked);
        mainBox.append(buttonStop);

        timeoutId = 0;
        connectUnrealize(&onWindowDestroy);
    }

    void onButtonStartClicked(Button widget)
    {
        startTimer();
    }

    void onButtonStopClicked(Button widget)
    {
        stopTimer("Stopped from button");
    }

    void onWindowDestroy(Widget widget)
    {
        if (timeoutId)
        {
            Source.remove(timeoutId);
            timeoutId = 0;
        }
    }

    bool onTimeout()
    {
        counter--;
        if (counter <= 0)
        {
            stopTimer("Reached time out");
            return false;
        }
        label.setText("Remaining: " ~ to!string(counter / 4));
        return true;
    }

    void startTimer()
    {
        buttonStart.setSensitive(false);
        buttonStop.setSensitive(true);
        
        counter = 4 * to!int(entry.getText);
        label.setText("Remaining: " ~ to!string(counter / 4));
        spinner.start;
        timeoutId = timeoutAdd(PRIORITY_DEFAULT, 250, &onTimeout); // 250ms
    }

    void stopTimer(string labelText)
    {
        if (timeoutId)
        {
            Source.remove(timeoutId);
            timeoutId = 0;
        }
        spinner.stop;
        buttonStart.setSensitive(true);
        buttonStop.setSensitive(false);
        label.setText(labelText);
    }
}
