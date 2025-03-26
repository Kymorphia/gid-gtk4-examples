module spinner;

import glib.global : timeoutAdd;
import glib.source : Source;
import glib.types : PRIORITY_DEFAULT;
import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.button;
import gtk.entry;
import gtk.label;
import gtk.spinner;
import gtk.types : Orientation;
import gtk.widget;

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

    void onButtonStartClicked()
    {
        startTimer();
    }

    void onButtonStopClicked()
    {
        stopTimer("Stopped from button");
    }

    void onWindowDestroy()
    {   // Remove the timeout callback if it is active
        if (timeoutId != 0)
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
