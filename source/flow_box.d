module flow_box;

import cairo.Context;
import Gdk.RGBA;
import Gtk.Application;
import Gtk.ApplicationWindow;
import Gtk.Button;
import Gtk.DrawingArea;
import Gtk.FlowBox;
import Gtk.Global : renderBackground;
import Gtk.HeaderBar;
import Gtk.ScrolledWindow;
import Gtk.Types : Align, PolicyType, SelectionMode;

import example;

final class FlowBoxExample : Example
{
    override @property ExampleCategory category() { return ExampleCategory.Containers; }
    override ApplicationWindow createWindow(Application app) { return new FlowBoxWindow(app); }
}

class FlowBoxWindow : ApplicationWindow
{
    this(Application app)
    {
        super(app);
        setTitle("FlowBox Demo");
        setDefaultSize(300, 250);

        auto header = new HeaderBar;
        setTitlebar(header);

        auto scrolled = new ScrolledWindow;
        scrolled.setPolicy(PolicyType.Never, PolicyType.Automatic);
        setChild(scrolled);

        auto flowbox = new FlowBox;
        flowbox.setValign(Align.Start);
        flowbox.setMaxChildrenPerLine(30);
        flowbox.setSelectionMode(SelectionMode.None);
        scrolled.setChild(flowbox);

        createFlowbox(flowbox);
    }

    void createFlowbox(FlowBox flowbox)
    {
        string[] colors = [
            "AliceBlue", "AntiqueWhite", "AntiqueWhite1", "AntiqueWhite2", "AntiqueWhite3", "AntiqueWhite4",
            "aqua", "aquamarine", "aquamarine1", "aquamarine2", "aquamarine3", "aquamarine4", "azure", 
            "azure1", "azure2", "azure3", "azure4", "beige", "bisque", "bisque1", "bisque2", "bisque3", 
            "bisque4", "black", "BlanchedAlmond", "blue", "blue1", "blue2", "blue3", "blue4", "BlueViolet",
            "brown", "brown1", "brown2", "brown3", "brown4", "burlywood", "burlywood1", "burlywood2", 
            "burlywood3", "burlywood4", "CadetBlue", "CadetBlue1", "CadetBlue2", "CadetBlue3", 
            "CadetBlue4", "chartreuse", "chartreuse1", "chartreuse2", "chartreuse3", "chartreuse4", 
            "chocolate", "chocolate1", "chocolate2", "chocolate3", "chocolate4", "coral", "coral1", 
            "coral2", "coral3", "coral4"
        ];

        foreach (color; colors)
        {
            auto button = new ColorSwatch(color);
            button.setTooltipText(color);
            flowbox.append(button);
        }
    }
}

class ColorSwatch : Button
{
    RGBA color;

    this(string strColor)
    {
        color = new RGBA;
        color.parse(strColor);

        auto area = new DrawingArea;
        area.setSizeRequest(24, 24);
        area.setDrawFunc(&drawButtonColor);
        setChild(area);
    }

    void drawButtonColor(DrawingArea area, Context cr, int width, int height)
    {
        auto context = area.getStyleContext;
        context.renderBackground(cr, 0, 0, width, height);

        cr.setSourceRgba(color.red, color.green, color.blue, color.alpha);
        cr.rectangle(0, 0, width, height);
        cr.fill;
    }
}
