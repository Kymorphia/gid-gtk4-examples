module label;

import gobject.object;
import gobject.param_spec;
import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.button;
import gtk.label;
import gtk.types : Justification, Orientation;
import std.stdio : writeln;
import std.string : split;

import example;

class LabelExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Display; }
    override ApplicationWindow createWindow(Application app) { return new LabelWindow(app); }
}

class LabelWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("Label Demo");

        Box box = new Box(Orientation.Horizontal, 10);
        setChild(box);

        Box boxLeft = new Box(Orientation.Vertical, 10);
        boxLeft.setHexpand(true);
        boxLeft.setHomogeneous(true);
        Box boxRight = new Box(Orientation.Vertical, 10);

        box.append(boxLeft);
        box.append(boxRight);

        // Left side labels
        Label label = new Label("This is a normal label");
        boxLeft.append(label);

        label = new Label("This is a normal label with xalign set to 0");
        label.setXalign(0);
        boxLeft.append(label);

        label = new Label(cast(string)null);
        label.setLabel("This is a left-justified label.\nWith multiple lines.");
        label.setJustify(Justification.Left);
        boxLeft.append(label);

        label = new Label("This is a right-justified label.\nWith multiple lines.");
        label.setJustify(Justification.Right);
        boxLeft.append(label);

        label = new Label(
            "This is an example of a line-wrapped label. It should not be taking up the entire width allocated to it, but automatically wraps the words to fit.\n" ~
            "     It supports multiple paragraphs correctly, and  correctly   adds many          extra  spaces. "
        );
        label.setWrap(true);
        label.setMaxWidthChars(32);
        boxRight.append(label);

        label = new Label(
            "This is an example of a line-wrapped, filled label. It should be taking up the entire width allocated to it. Here is a sentence to prove my point. Here is another sentence. Here comes the sun, do de do de do.\n" ~
            "    This is a new paragraph.\n" ~
            "    This is another newer, longer, better paragraph. It is coming to an end, unfortunately."
        );
        label.setWrap(true);
        label.setJustify(Justification.Fill);
        label.setMaxWidthChars(32);
        boxRight.append(label);

        label = new Label(cast(string)null);
        label.setMarkup(
            "Text can be <small>small</small>, <big>big</big>, <b>bold</b>, <i>italic</i> and even point to somewhere in the <a href=\"https://www.gtk.org\" title=\"Click to find out more\">internets</a>."
        );
        label.setWrap(true);
        label.setMaxWidthChars(48);
        boxLeft.append(label);

        label = Label.newWithMnemonic("_Press Alt + P to select button to the right");
        boxLeft.append(label);
        label.setSelectable(true);

        Button button = Button.newWithLabel("Click at your own risk");
        label.setMnemonicWidget(button);
        boxRight.append(button);
    }
}
