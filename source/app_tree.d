module app_tree;

import gio.list_model;
import gio.list_store;
import gobject.object;
import gobject.types : GTypeEnum;
import gtk.application;
import gtk.column_view;
import gtk.column_view_column;
import gtk.label;
import gtk.list_item;
import gtk.scrolled_window;
import gtk.signal_list_item_factory;
import gtk.single_selection;
import gtk.tree_expander;
import gtk.tree_list_model;
import gtk.tree_list_row;
import std.algorithm : canFind, map, sort;
import std.array : array, join, split;
import std.ascii : uppercase;
import std.conv : to;
import std.string : chomp, strip;
import std.traits : EnumMembers;

import example;

class AppTree : ScrolledWindow
{
  this(Application app)
  {
    this.app = app;
    createCategoryExampleItems;

    setVexpand(true);

    auto listModelRoot = createListModel(createTreeItem(new CategoryItem(ExampleCategory.Default))); // Create top-level list model for root node
    auto treeListModel = new TreeListModel(listModelRoot, false, false, &createListModel); // root, passthrough, autoexpand, createFunc
    auto selModel = new SingleSelection(treeListModel);
    auto columnView = new ColumnView(selModel);
    setChild(columnView);

    columnView.connectActivate(&onColumnViewActivate);

    auto factory = new SignalListItemFactory();
    factory.connectSetup(&onNameItemSetup);
    factory.connectBind(&onNameItemBind);
    auto col = new ColumnViewColumn("Name", factory);
    columnView.appendColumn(col);
    col.setExpand(true);
  }

  /// Populate categoryExampleItems with Example and CategoryItem objects
  private void createCategoryExampleItems()
  {
    auto exampleClass = typeid(Example);

    // Loop over classes in all modules and add Example derived classes to example tree item hash
    foreach (mod; ModuleInfo)
    {
      foreach (cl; mod.localClasses)
      {
        if (cl !is exampleClass && exampleClass.isBaseOf(cl))
        {
          auto example = cast(Example)cl.create;
          categoryExampleItems[example.category] ~= example;
        }
      }
    }

    // Add categories to example tree item hash under Default category
    foreach (cat; [EnumMembers!ExampleCategory])
      if (cat != ExampleCategory.Default)
        categoryExampleItems[ExampleCategory.Default] ~= new CategoryItem(cat);

    // Sort the items by name
    foreach (cat, objs; categoryExampleItems)
      categoryExampleItems[cat] = objs.sort!((a, b) => itemObjName(a) < itemObjName(b)).array;
  }

  private ListModel createListModel(ObjectG item)
  {
    auto listStore = new ListStore(GTypeEnum.Object);
    auto appItem = cast(AppTreeItem)item;
    appItem.listStore = listStore;

    // If this is a category item, add children Example and CategoryItem objects
    if (auto catItem = cast(CategoryItem)appItem.exampleObject)
      foreach (obj; categoryExampleItems.get(catItem.category, []))
        listStore.append(createTreeItem(obj));

    return listStore;
  }

  private AppTreeItem createTreeItem(Object exampleObject)
  {
    return new AppTreeItem(exampleObject);
  }

  private void onNameItemSetup(ObjectG obj, SignalListItemFactory factory)
  {
    auto treeExpander = new TreeExpander;
    treeExpander.setChild(new Label(cast(string)null));
    (cast(ListItem)obj).setChild(treeExpander);
  }

  private void onNameItemBind(ObjectG obj, SignalListItemFactory factory)
  {
    auto listItem = cast(ListItem)obj;
    auto treeListRow = cast(TreeListRow)listItem.getItem;
    treeListRow.setExpanded(true);
    auto appItem = cast(AppTreeItem)treeListRow.getItem;

    auto treeExpander = cast(TreeExpander)listItem.getChild;

    appItem.treeExpander = treeExpander;
    treeExpander.setListRow(treeListRow);

    bool hideExpander;

    if (auto cat = cast(CategoryItem)appItem.exampleObject)
      hideExpander = cat.category != ExampleCategory.Default && cat.category !in categoryExampleItems; // Hide expander on categories which don't have any Examples
    else
      hideExpander = true; // Hide expander on Example items

    treeExpander.setHideExpander(hideExpander);

    auto label = cast(Label)treeExpander.getChild;
    label.setText(itemObjName(appItem.exampleObject));
  }

  private void onColumnViewActivate(uint position, ColumnView columnView)
  {
    auto selModel = cast(SingleSelection)columnView.getModel;
    auto treeListRow = cast(TreeListRow)selModel.getModel.getItem(position);
    auto appItem = cast(AppTreeItem)treeListRow.getItem;

    if (auto example = cast(Example)appItem.exampleObject)
    {
      auto window = example.createWindow(app);
      window.present;
    }
  }

private:
  Application app;
  Object[][ExampleCategory] categoryExampleItems; // Hash of object arrays (Example and CategoryItem) by category enum
}

/// Used in AppTree.categoryExampleItems as a category placeholder
class CategoryItem
{
  this(ExampleCategory category)
  {
    this.category = category;
  }

  ExampleCategory category;
}

/**
 * Get the name representation of an Example or CategoryItem object.
 * Params:
 *   obj = The object which is derived from Example or CategoryItem
 * Returns: Name of the object
 */
string itemObjName(Object obj)
{
  string name;

  if (auto example = cast(Example)obj)
    name = typeid(example).name.split('.')[$ - 1].chomp("Example"); // Get last component of pkg.mod.ClassName and remove "Example" from the end
  else if (auto cat = cast(CategoryItem)obj)
    name = cat.category.to!string;
  else
    assert(0, typeid(obj).name ~ " is not an Example or CategoryItem object");

  return name.map!(x => uppercase.canFind(x) ? (" " ~ [x]) : [x]).join.strip.to!string; // Separate uppercase words by spaces
}

/// GObject wrapper for an item in a ListModel for AppTree ColumnView
class AppTreeItem : ObjectG
{
  mixin(objectGMixin); // Include expected boilerplate ObjectG constructors

  /**
   * Create a new tree item.
   * Params:
   *   itemObject = Example derived object or a CategoryItem
   */
  this(Object exampleObject)
  {
    super(GTypeEnum.Object);
    this.exampleObject = exampleObject;
  }

  Object exampleObject;
  ListStore listStore;
  TreeExpander treeExpander;
}
