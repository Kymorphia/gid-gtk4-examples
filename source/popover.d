module popover;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.button;
import gtk.label;
import gtk.menu_button;
import gtk.popover;
import gtk.types : Align, Orientation, PositionType;

import example;

class PopoverExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Default; }
    override ApplicationWindow createWindow(Application app) { return new PopoverWindow(app); }
}

class PopoverWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Popover Demo");
        setDefaultSize(300, 200);

        Box box = new Box(Orientation.Vertical, 6);
        box.setHalign(Align.Center);
        box.setValign(Align.Center);
        setChild(box);

        Popover popover = new Popover();
        Box popoverBox = new Box(Orientation.Horizontal, 0);
        popoverBox.append(new Label("Item"));
        popover.setChild(popoverBox);

        MenuButton button = new MenuButton;
        button.setLabel("Click Me");
        button.setPopover(popover);
        box.append(button);

        Button button2 = Button.newWithLabel("Click Me 2");
        box.append(button2);

        auto popover2 = new Popover();
        popover2.setChild(new Label("Another Popup!"));
        popover2.setParent(button2);
        popover2.setPosition(PositionType.Left);

        button2.connectClicked((Button btn) { popover2.popup; });
    }
}
