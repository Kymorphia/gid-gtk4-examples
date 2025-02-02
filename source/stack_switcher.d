module stack_switcher;

import GObject.Binding;
import GObject.Types : BindingFlags;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.CheckButton;
import Gtk.HeaderBar;
import Gtk.Label;
import Gtk.Stack;
import Gtk.StackSwitcher;
import Gtk.Types : Align, StackTransitionType;

import example;

class StackSwitcherExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new StackSwitcherWindow(app); }
}

class StackSwitcherWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Stack Demo");
        setDefaultSize(300, 250);

        auto header = new HeaderBar;
        setTitlebar(header);

        auto stack = new Stack;
        stack.setTransitionType(StackTransitionType.SlideLeftRight);
        stack.setTransitionDuration(1000);
        setChild(stack);

        auto checkbutton = CheckButton.newWithLabel("Click me!");
        checkbutton.setHexpand(true);
        checkbutton.setHalign(Align.Center);
        auto page1 = stack.addTitled(checkbutton, "check", "Check Button");
        checkbutton.bindProperty("active", page1, "needs-attention", BindingFlags.Default);

        auto label = new Label(cast(string)null);
        label.setMarkup("<big>A fancy label</big>");
        stack.addTitled(label, "label", "A label");

        auto stackSwitcher = new StackSwitcher;
        stackSwitcher.setStack(stack);
        header.setTitleWidget(stackSwitcher);

        // Let's start in the second page
        stack.setVisibleChildName("label");
    }
}
