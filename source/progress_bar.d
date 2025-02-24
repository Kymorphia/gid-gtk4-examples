module progress_bar;

import glib.global : timeoutAdd;
import glib.types : PRIORITY_DEFAULT;
import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.check_button;
import gtk.progress_bar;
import gtk.types : Orientation;

import example;

class ProgressBarExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Display; }
    override ApplicationWindow createWindow(Application app) { return new ProgressBarWindow(app); }
}

class ProgressBarWindow : ApplicationWindow
{
    ProgressBar progressbar;
    bool activityMode;
    uint timeoutId;

    this(Application app)
    {
        super(app);
        setTitle("ProgressBar Demo");

        Box vbox = new Box(Orientation.Vertical, 6);
        setChild(vbox);

        progressbar = new ProgressBar;
        vbox.append(progressbar);

        CheckButton showTextButton = CheckButton.newWithLabel("Show text");
        showTextButton.connectToggled(&onShowTextToggled);
        vbox.append(showTextButton);

        CheckButton activityModeButton = CheckButton.newWithLabel("Activity mode");
        activityModeButton.connectToggled(&onActivityModeToggled);
        vbox.append(activityModeButton);

        CheckButton rightToLeftButton = CheckButton.newWithLabel("Right to Left");
        rightToLeftButton.connectToggled(&onRightToLeftToggled);
        vbox.append(rightToLeftButton);

        timeoutId = timeoutAdd(PRIORITY_DEFAULT, 50, &onTimeout); // 50 ms interval
    }

    void onShowTextToggled(CheckButton button)
    {
        bool showText = button.getActive;
        progressbar.setText(showText ? "some text" : null);
        progressbar.setShowText(showText);
    }

    void onActivityModeToggled(CheckButton button)
    {
        if (auto activityMode = button.getActive)
            progressbar.pulse();
        else
            progressbar.setFraction(0.0);
    }

    void onRightToLeftToggled(CheckButton button)
    {
        progressbar.setInverted(button.getActive);
    }

    bool onTimeout()
    {
        if (activityMode)
            progressbar.pulse;
        else
            progressbar.setFraction((progressbar.getFraction() + 0.01) % 1.0);

        return true; // Return true to keep the timeout active
    }
}
