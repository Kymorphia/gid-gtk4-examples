module clipboard;

import gdk.clipboard;
import gdk.content_provider;
import gdk.display;
import gdk.texture;
import gio.async_result;
import glib.error;
import gobject.object;
import gobject.value;
import gtk.application;
import gtk.application_window;
import gtk.box;
import gtk.button;
import gtk.entry;
import gtk.picture;
import gtk.types : Align, Orientation;
import pango.types : Weight, Style, Underline;

import std.stdio : writeln;

import example;

class ClipboardExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Default; }
    override ApplicationWindow createWindow(Application app) { return new ClipboardWindow(app); }
}

class ClipboardWindow : ApplicationWindow
{
    Clipboard clipboard;
    Entry entry;
    Picture picture;

    this(Application app)
    {
        super(app);
        setTitle("Clipboard Example");

        auto box = new Box(Orientation.Vertical, 12);
        setChild(box);

        clipboard = Display.getDefault.getClipboard;

        auto textBox = new Box(Orientation.Horizontal, 6);
        textBox.setHomogeneous(true);
        box.append(textBox);

        entry = new Entry;
        entry.setText("Some text you can copy");
        auto buttonCopyText = Button.newWithLabel("Copy Text");
        buttonCopyText.connectClicked(&onCopyTextClicked);
        auto buttonPasteText = Button.newWithLabel("Paste Text");
        buttonPasteText.connectClicked(&onPasteTextClicked);

        textBox.append(entry);
        textBox.append(buttonCopyText);
        textBox.append(buttonPasteText);

        auto imageBox = new Box(Orientation.Horizontal, 6);
        box.append(imageBox);

        picture = Picture.newForFilename("images/dlang_logo.png");
        picture.setHexpand(true);
        auto buttonCopyImage = Button.newWithLabel("Copy Image");
        buttonCopyImage.setValign(Align.Center);
        buttonCopyImage.connectClicked(&onCopyImageClicked);
        auto buttonPasteImage = Button.newWithLabel("Paste Image");
        buttonPasteImage.setValign(Align.Center);
        buttonPasteImage.connectClicked(&onPasteImageClicked);

        imageBox.append(picture);
        imageBox.append(buttonCopyImage);
        imageBox.append(buttonPasteImage);
    }

    void onCopyTextClicked()
    {
        clipboard.set(new Value(entry.getText));
    }

    void onPasteTextClicked()
    {
        clipboard.readTextAsync(null, &clipboardReadTextAsync);
    }

    void clipboardReadTextAsync(ObjectWrap obj, AsyncResult result)
    {
        try
            if (auto text = clipboard.readTextFinish(result))
                entry.setText(text);
        catch (ErrorWrap err)
            writeln("Failed to read text from clipboard: ", err.message);
    }

    void onCopyImageClicked()
    {
        if (auto texture = cast(Texture)picture.getPaintable)
        {
            auto content = ContentProvider.newForBytes("image/png", texture.saveToPngBytes);
            clipboard.setContent(content);
        }
    }

    void onPasteImageClicked()
    {
        clipboard.readTextureAsync(null, &clipboardReadTextureAsync);
    }

    void clipboardReadTextureAsync(ObjectWrap obj, AsyncResult result)
    {
        try
            if (auto texture = clipboard.readTextureFinish(result))
                picture.setPaintable(texture);
        catch (ErrorWrap err)
            writeln("Failed to read a texture from clipboard: ", err.message);
    }
}
