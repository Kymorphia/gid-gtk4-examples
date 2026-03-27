module text_view;

import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.button;
import gtk.check_button;
import gtk.grid;
import gtk.label;
import gtk.scrolled_window;
import gtk.search_entry;
import gtk.separator;
import gtk.text_buffer;
import gtk.text_iter;
import gtk.text_tag;
import gtk.text_view;
import gtk.toggle_button;
import gtk.types : Justification, Orientation, PositionType, WrapMode, TextSearchFlags;
import pango.types : Weight, Style, Underline;
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

        // Leak work around to break C/D reference cycles
        connectCloseRequest(() {
            textview = null;
            textbuffer = null;
            box = null;
            tagBold = tagItalic = tagUnderline = tagFound = null;
            return false; // Let other handlers run
        });
    }

    void createTextView()
    {
        ScrolledWindow scrolledWindow = ScrolledWindow.builder.hexpand(true).vexpand(true).build;
        box.append(scrolledWindow);

        textview = new TextView;
        textbuffer = textview.getBuffer;
        textbuffer.setText(
            "This is some text inside of a Gtk.TextView. " ~
            "Select text and click one of the buttons \"bold\", \"italic\", " ~
            "or \"underline\" to modify the text accordingly."
        );
        scrolledWindow.setChild(textview);

        tagBold = TextTag.builder.name("bold").weight(Weight.Bold).build;
        textbuffer.getTagTable.add(tagBold);

        tagItalic = TextTag.builder.name("italic").style(Style.Italic).build;
        textbuffer.getTagTable.add(tagItalic);

        tagUnderline = TextTag.builder.name("underline").underline(Underline.Single).build;
        textbuffer.getTagTable.add(tagUnderline);

        tagFound = TextTag.builder.name("found").background("yellow").build;
        textbuffer.getTagTable.add(tagFound);
    }

    void createToolbar()
    {
        Box toolbar = Box.builder.orientation(Orientation.Horizontal).spacing(6)
            .marginTop(6).marginStart(6).marginEnd(6).build;
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
        auto justifyLeft = ToggleButton.builder.iconName("format-justify-left-symbolic").build;
        toolbar.append(justifyLeft);

        justifyLeft.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Left);
        });

        auto justifyCenter = ToggleButton.builder.iconName("format-justify-center-symbolic").group(justifyLeft).build;
        toolbar.append(justifyCenter);

        justifyCenter.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Center);
        });

        auto justifyRight = ToggleButton.builder.iconName("format-justify-right-symbolic").group(justifyLeft).build;
        toolbar.append(justifyRight);

        justifyRight.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Right);
        });

        auto justifyFill = ToggleButton.builder.iconName("format-justify-fill-symbolic").group(justifyLeft).build;
        toolbar.append(justifyFill);

        justifyFill.connectToggled((ToggleButton btn) {
            if (btn.getActive) textview.setJustification(Justification.Fill);
        });

        toolbar.append(new Separator(Orientation.Vertical));

        auto buttonClear = Button.builder.iconName("edit-clear-symbolic")
            .tooltipText("Clear text buffer formatting tags").build;
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

        auto checkEditable = CheckButton.builder.label("Editable").active(true).build;
        checkEditable.connectToggled(&onEditableToggled);
        grid.attach(checkEditable, 0, 0, 1, 1);

        auto checkCursor = CheckButton.builder.label("Cursor Visible").active(true).build;
        checkEditable.connectToggled(&onCursorToggled); // Note: This should be checkCursor
        grid.attachNextTo(checkCursor, checkEditable, PositionType.Right, 1, 1);

        auto radioWrapNone = CheckButton.builder.label("No Wrapping").active(true).build;
        radioWrapNone.connectToggled((CheckButton btn) { textview.setWrapMode(WrapMode.None); });
        grid.attach(radioWrapNone, 0, 1, 1, 1);

        auto radioWrapChar = CheckButton.builder.label("Character Wrapping").group(radioWrapNone).build;
        radioWrapChar.connectToggled((CheckButton btn) { textview.setWrapMode(WrapMode.Char); });
        grid.attachNextTo(radioWrapChar, radioWrapNone, PositionType.Right, 1, 1);

        auto radioWrapWord = CheckButton.builder.label("Word Wrapping").group(radioWrapNone).build;
        radioWrapWord.connectToggled((CheckButton btn) { textview.setWrapMode(WrapMode.Word); });
        grid.attachNextTo(radioWrapWord, radioWrapChar, PositionType.Right, 1, 1);
    }

    void onClearClicked()
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
