module clipboard;

import Gdk.Clipboard;
import Gdk.ContentProvider;
import Gdk.Display;
import Gdk.Texture;
import Gio.AsyncResult;
import GObject.ObjectG;
import GObject.Value;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Box;
import Gtk.Button;
import Gtk.Entry;
import Gtk.Picture;
import Gtk.Types : Align, Orientation;
import Pango.Types : Weight, Style, Underline;

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

    void onCopyTextClicked(Button button)
    {
        clipboard.set(new Value(entry.getText));
    }

    void onPasteTextClicked(Button button)
    {
        clipboard.readTextAsync(null, &clipboardReadTextAsync);
    }

    void clipboardReadTextAsync(ObjectG obj, AsyncResult result)
    {
        if (auto text = clipboard.readTextFinish(result))
            entry.setText(text);
    }

    void onCopyImageClicked(Button button)
    {
        if (auto texture = cast(Texture)picture.getPaintable)
        {
            auto content = ContentProvider.newForBytes("image/png", texture.saveToPngBytes);
            clipboard.setContent(content);
        }
    }

    void onPasteImageClicked(Button button)
    {
        clipboard.readTextureAsync(null, &clipboardReadTextureAsync);
    }

    void clipboardReadTextureAsync(ObjectG obj, AsyncResult result)
    {
        if (auto texture = clipboard.readTextureFinish(result))
            picture.setPaintable(texture);
    }
}
