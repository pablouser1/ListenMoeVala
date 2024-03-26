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
    win.set_default_size(400, 200);

    // Label
    var label = new Gtk.Label("Welcome to ListenMoeVala!");
    // Image
    var s = new Soup.Session();
    var img = new Gtk.Picture();
    img.set_can_shrink(true);
    img.set_size_request(128, 128);

    ws.on_new_song.connect((song) => {
        refresh_song.begin(song, label, img, s);
    });

    ws.connect.begin();
    player.start();

    // Main grid
    var grid = new Gtk.Grid();
    grid.set_hexpand(true);
    grid.set_vexpand(true);
    grid.set_row_spacing(5);
    grid.set_column_spacing(5);
    grid.attach(label, 0, 0);
    grid.attach(img, 1, 0);
    win.set_child(grid);
    win.present();
}

private async void refresh_song(Song song, Gtk.Label label, Gtk.Picture img, Soup.Session s) {
    // Handle label
    var title = song.name();
    var artist = song.artist();
    var album = song.album();

    var str = @"$title\nBy $artist";

    if (album != null) {
        str += @"\n$(album.name)";
    }

    label.set_text(str);

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
    }
}
