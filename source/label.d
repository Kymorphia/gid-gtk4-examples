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

        Box boxLeft = Box.builder.orientation(Orientation.Vertical).spacing(10).hexpand(true).homogeneous(true).build;
        Box boxRight = new Box(Orientation.Vertical, 10);
        box.append(boxLeft);
        box.append(boxRight);

        boxLeft.append(new Label("This is a normal label"));
        boxLeft.append(Label.builder.label("This is a normal label with xalign set to 0").xalign(0).build);
        boxLeft.append(Label.builder.label("This is a left-justified label.\nWith multiple lines.")
            .justify(Justification.Left).build);
        boxLeft.append(Label.builder.label("This is a right-justified label.\nWith multiple lines.")
            .justify(Justification.Right).build);
        boxRight.append(Label.builder.label(
            "This is an example of a line-wrapped label. It should not be taking up the entire width allocated to it, "
            ~ "but automatically wraps the words to fit.\n     It supports multiple paragraphs correctly, and  "
            ~ "correctly   adds many          extra  spaces. ")
            .wrap(true).maxWidthChars(32).build);
        boxRight.append(Label.builder.label(
            "This is an example of a line-wrapped, filled label. It should be taking up the entire width allocated to "
            ~ "it. Here is a sentence to prove my point. Here is another sentence. Here comes the sun, do de do de do."
            ~ "\n    This is a new paragraph.\n    This is another newer, longer, better paragraph. "
            ~ "It is coming to an end, unfortunately.")
            .wrap(true).justify(Justification.Fill).maxWidthChars(32).build);
        boxLeft.append(Label.builder.label("Text can be <small>small</small>, <big>big</big>, <b>bold</b>, "
            ~ "<i>italic</i> and even point to somewhere in the <a href=\"https://www.gtk.org\" title=\"Click to find "
            ~ "out more\">internets</a>.")
            .useMarkup(true).wrap(true).maxWidthChars(48).build);

        auto label = Label.newWithMnemonic("_Press Alt + P to select button to the right");
        label.selectable = true;
        boxLeft.append(label);

        Button button = Button.newWithLabel("Click at your own risk");
        label.mnemonicWidget = button;
        boxRight.append(button);
    }
}
