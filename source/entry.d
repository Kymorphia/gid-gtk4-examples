module entry;

import GLib.Global : timeoutAdd;
import GLib.Source;
import GLib.Types : PRIORITY_DEFAULT;
import GObject.Value;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.CheckButton;
import Gtk.Entry;
import Gtk.HeaderBar;
import Gtk.PasswordEntry;
import Gtk.SearchEntry;
import Gtk.Types : EntryIconPosition, Orientation;

import example;

class EntryExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Controls; }
    override ApplicationWindow createWindow(Application app) { return new EntryWindow(app); }
}

class EntryWindow : ApplicationWindow
{
    Entry entry;
    CheckButton checkEditable, checkVisible, pulse, icon;
    uint timeoutId;

    this(Application app)
    {
        super(app);
        setTitle("Entry Demo");
        setSizeRequest(200, 100);

        auto header = new HeaderBar;
        setTitlebar(header);

        auto vbox = new Box(Orientation.Vertical, 6);
        vbox.setMarginStart = 24;
        vbox.setMarginEnd = 24;
        vbox.setMarginTop = 24;
        vbox.setMarginBottom = 24;
        setChild(vbox);

        // Gtk.SearchEntry
        auto search = new SearchEntry;
        search.setPlaceholderText = "Search Entry";
        search.setKeyCaptureWidget(this);
        header.setTitleWidget(search);
        setFocus(search);

        // Gtk.Entry
        entry = new Entry;
        entry.setText("Hello World");
        vbox.append(entry);

        auto hbox = new Box(Orientation.Horizontal, 6);
        vbox.append(hbox);

        checkEditable = CheckButton.newWithLabel("Editable");
        checkEditable.connectToggled(&onEditableToggled);
        checkEditable.setActive = true;
        hbox.append(checkEditable);

        checkVisible = CheckButton.newWithLabel("Visible");
        checkVisible.connectToggled(&onVisibleToggled);
        checkVisible.setActive = true;
        hbox.append(checkVisible);

        pulse = CheckButton.newWithLabel("Pulse");
        pulse.connectToggled(&onPulseToggled);
        hbox.append(pulse);

        icon = CheckButton.newWithLabel("Icon");
        icon.connectToggled(&onIconToggled);
        hbox.append(icon);

        // Gtk.PasswordEntry
        auto passEntry = new PasswordEntry;
        passEntry.setProperty("placeholder-text", new Value("Password Entry"));
        passEntry.setShowPeekIcon = true;
        passEntry.setMarginTop = 24;
        vbox.append(passEntry);
    }

    void onEditableToggled(CheckButton button)
    {
        entry.setEditable(button.getActive);
    }

    void onVisibleToggled(CheckButton button)
    {
        entry.setVisibility = button.getActive;
    }

    void onPulseToggled(CheckButton button)
    {
        if (button.getActive)
        {
            entry.setProgressPulseStep = 0.2;
            timeoutId = timeoutAdd(PRIORITY_DEFAULT, 100, &doPulse);
        }
        else
        {
            Source.remove(timeoutId);
            entry.setProgressPulseStep = 0;
        }
    }

    bool doPulse()
    {
        entry.progressPulse;
        return true;
    }

    void onIconToggled(CheckButton button)
    {
        string iconName = button.getActive ? "system-search-symbolic" : null;
        entry.setIconFromIconName(EntryIconPosition.Primary, iconName);
    }
}
