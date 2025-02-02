module text_view;

import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.Button;
import Gtk.CheckButton;
import Gtk.Grid;
import Gtk.Label;
import Gtk.ScrolledWindow;
import Gtk.SearchEntry;
import Gtk.Separator;
import Gtk.TextBuffer;
import Gtk.TextIter;
import Gtk.TextTag;
import Gtk.TextView;
import Gtk.ToggleButton;
import Gtk.Types : Justification, Orientation, PositionType, WrapMode, TextSearchFlags;
import Pango.Types : Weight, Style, Underline;
import std.conv : to;
import std.stdio : writeln;

import example;

class TextViewExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Default; }
    override ApplicationWindow createWindow(Application app) { return new TextViewWindow(app); }
}

class TextViewWindow : ApplicationWindow
{
    ApplicationWindow window;
    TextView textview;
    TextBuffer textbuffer;
    TextTag tagBold, tagItalic, tagUnderline, tagFound;
    Box box;

    this(Application app)
    {
        super(app);
        setTitle("TextView Demo");
        setDefaultSize(500, 400);

        box = new Box(Orientation.Vertical, 6);
        setChild(box);

        createTextView;
        createToolbar;
        createButtons;
    }

    void createTextView()
    {
        ScrolledWindow scrolledWindow = new ScrolledWindow;
        scrolledWindow.setHexpand(true);
        scrolledWindow.setVexpand(true);
        box.append(scrolledWindow);

        textview = new TextView;
        textbuffer = textview.getBuffer;
        textbuffer.setText(
            "This is some text inside of a Gtk.TextView. " ~
            "Select text and click one of the buttons \"bold\", \"italic\", " ~
            "or \"underline\" to modify the text accordingly."
        );
        scrolledWindow.setChild(textview);

        tagBold = new TextTag("bold");
        tagBold.setProperty("weight", Weight.Bold);
        textbuffer.getTagTable.add(tagBold);

        tagItalic = new TextTag("italic");
        tagItalic.setProperty("style", Style.Italic);
        textbuffer.getTagTable.add(tagItalic);

        tagUnderline = new TextTag("underline");
        tagUnderline.setProperty("underline", Underline.Single);
        textbuffer.getTagTable.add(tagUnderline);

        tagFound = new TextTag("found");
        tagFound.setProperty("background", "yellow");
        textbuffer.getTagTable.add(tagFound);
    }

    void createToolbar()
    {
        Box toolbar = new Box(Orientation.Horizontal, 6);
        toolbar.setMarginTop(6);
        toolbar.setMarginStart(6);
        toolbar.setMarginEnd(6);
        box.prepend(toolbar);

        void applyTag(TextTag tag)
        {
            TextIter start, end;
            if (textbuffer.getSelectionBounds(start, end))
                textbuffer.applyTag(tag, start, end);
        }

        auto buttonBold = Button.newFromIconName("format-text-bold-symbolic");
        buttonBold.connectClicked((Button btn) { applyTag(tagBold); });
        toolbar.append(buttonBold);

        auto buttonItalic = Button.newFromIconName("format-text-italic-symbolic");
        buttonItalic.connectClicked((Button btn) { applyTag(tagItalic); });
        toolbar.append(buttonItalic);

        auto buttonUnderline = Button.newFromIconName("format-text-underline-symbolic");
        buttonUnderline.connectClicked((Button btn) { applyTag(tagUnderline); });
        toolbar.append(buttonUnderline);

        toolbar.append(new Separator(Orientation.Vertical));

        // newFromIconName is a method of parent Button class, cast return value to ToggleButton
        auto justifyLeft = new ToggleButton;
        justifyLeft.setIconName("format-justify-left-symbolic");
        toolbar.append(justifyLeft);

        justifyLeft.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Left);
        });

        auto justifyCenter = new ToggleButton;
        justifyCenter.setIconName("format-justify-center-symbolic");
        justifyCenter.setGroup(justifyLeft);
        toolbar.append(justifyCenter);

        justifyCenter.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Center);
        });

        auto justifyRight = new ToggleButton;
        justifyRight.setIconName("format-justify-right-symbolic");
        justifyRight.setGroup(justifyLeft);
        toolbar.append(justifyRight);

        justifyRight.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Right);
        });

        auto justifyFill = new ToggleButton;
        justifyFill.setIconName("format-justify-fill-symbolic");
        justifyFill.setGroup(justifyLeft);
        toolbar.append(justifyFill);

        justifyFill.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Fill);
        });

        toolbar.append(new Separator(Orientation.Vertical));

        auto buttonClear = Button.newFromIconName("edit-clear-symbolic");
        buttonClear.setTooltipText("Clear text buffer formatting tags");
        buttonClear.connectClicked(&onClearClicked);
        toolbar.append(buttonClear);

        toolbar.append(new Separator(Orientation.Vertical));

        auto searchEntry = new SearchEntry;
        searchEntry.connectActivate(&onSearchEntryActivate);
        toolbar.append(searchEntry);
    }

    void createButtons()
    {
        Grid grid = new Grid;
        box.append(grid);

        auto checkEditable = CheckButton.newWithLabel("Editable");
        checkEditable.setActive(true);
        checkEditable.connectToggled(&onEditableToggled);
        grid.attach(checkEditable, 0, 0, 1, 1);

        auto checkCursor = CheckButton.newWithLabel("Cursor Visible");
        checkCursor.setActive(true);
        checkEditable.connectToggled(&onCursorToggled); // Note: This should be checkCursor
        grid.attachNextTo(checkCursor, checkEditable, PositionType.Right, 1, 1);

        auto radioWrapNone = CheckButton.newWithLabel("No Wrapping");
        radioWrapNone.setActive(true);
        radioWrapNone.connectToggled((CheckButton btn) { textview.setWrapMode(WrapMode.None); });
        grid.attach(radioWrapNone, 0, 1, 1, 1);

        auto radioWrapChar = CheckButton.newWithLabel("Character Wrapping");
        radioWrapChar.setGroup(radioWrapNone);
        radioWrapChar.connectToggled((CheckButton btn) { textview.setWrapMode(WrapMode.Char); });
        grid.attachNextTo(radioWrapChar, radioWrapNone, PositionType.Right, 1, 1);

        auto radioWrapWord = CheckButton.newWithLabel("Word Wrapping");
        radioWrapWord.setGroup(radioWrapNone);
        radioWrapWord.connectToggled((CheckButton btn) { textview.setWrapMode(WrapMode.Word); });
        grid.attachNextTo(radioWrapWord, radioWrapChar, PositionType.Right, 1, 1);
    }

    void onClearClicked(Button widget)
    {
        TextIter start, end;
        textbuffer.getStartIter(start);
        textbuffer.getEndIter(end);
        textbuffer.removeAllTags(start, end);
    }

    void onEditableToggled(CheckButton widget)
    {
        textview.setEditable(widget.getActive);
    }

    void onCursorToggled(CheckButton widget)
    {
        textview.setCursorVisible(widget.getActive);
    }

    void onSearchEntryActivate(SearchEntry searchEntry)
    {
        TextIter start;
        textbuffer.getIterAtMark(start, textbuffer.getInsert);

        if (start.getOffset == textbuffer.getCharCount)
            textbuffer.getStartIter(start);

        searchAndMark(searchEntry.getText, start);
    }

    void searchAndMark(string text, TextIter from)
    {
        TextIter matchStart, matchEnd;
        if (from.forwardSearch(text, TextSearchFlags.TextOnly, matchStart, matchEnd, null)) // null is for the Limit argument, which would limit the search
        {
            textbuffer.applyTag(tagFound, matchStart, matchEnd);
            searchAndMark(text, matchEnd);
        }
    }
}
