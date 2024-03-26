public int gui(Player player, Websocket ws, string[] argv) {
    // Create a new application
    var app = new Gtk.Application("com.pablouser1.listenmoe", GLib.ApplicationFlags.DEFAULT_FLAGS);
    app.activate.connect(() => {
        home_window(player, ws, app);
    });
    return app.run(argv);
}

private void home_window(Player player, Websocket ws, Gtk.Application app) {
    var win = new Gtk.ApplicationWindow(app);
    win.set_title("ListenMoe");
    win.set_default_size(400, 200);

    var header = new Gtk.HeaderBar();
    win.set_titlebar(header);

    // Label
    var label = new Gtk.Label("Welcome to ListenMoeVala!");
    // Listeners
    var listeners = new Gtk.Label("Listeners: 0");
    // Image
    var s = new Soup.Session();
    var img = new Gtk.Picture();
    img.set_can_shrink(true);
    img.set_size_request(128, 128);
    ws.on_new_song.connect((song) => {
        refresh_song.begin(song, label, img, listeners, s);
    });

    ws.connect.begin();
    player.start();

    // Controls
    var toggle = new Gtk.Button();
    toggle.set_label("Play / Pause");
    toggle.clicked.connect(() => {
        player.toggle();
    });

    var vol = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, 1, 0.1);
    vol.set_value(player.vol);
    vol.value_changed.connect(() => {
        player.volume(vol.get_value());
    });
    
    // Main grid
    var grid = new Gtk.Grid();
    grid.set_margin_top(5);
    grid.set_hexpand(true);
    grid.set_vexpand(true);
    grid.set_row_spacing(5);
    grid.set_column_spacing(5);
    grid.attach(label, 0, 0);
    grid.attach(img, 1, 0);
    grid.attach(toggle, 0, 1);
    grid.attach(vol, 1, 1);
    grid.attach(listeners, 2, 1);
    win.set_child(grid);
    win.present();
}

private async void refresh_song(Data data, Gtk.Label label, Gtk.Picture img, Gtk.Label listeners, Soup.Session s) {
    // Handle label
    var title = data.getName();
    var artist = data.getArtist();
    var album = data.getAlbum();

    var str = @"$title\nBy $artist";

    if (album != null) {
        str += @"\n$(album.name)";
    }

    label.set_text(str);

    listeners.set_label(@"Listeners: $(data.getListeners())");

    // Handle image
    if (album != null && album.cover != null) {
        var msg = new Soup.Message("GET", @"https://cdn.listen.moe/covers/$(album.cover)");
        try {
            var res = yield s.send_async(msg, 0, null);
            var buf = new Gdk.Pixbuf.from_stream(res);

            var texture = Gdk.Texture.for_pixbuf(buf);
            img.set_paintable(texture);
        } catch (GLib.Error e) {
            error(e.message);
        }
    } else {
        img.set_paintable(null);
    }
}
