Genre? genre_picker(string genre_str) {
    Genre? genre = null;
    switch (genre_str) {
        case "j":
        case "jpop":
            genre = JPOP_GENRE;
            break;
        case "k":
        case "kpop":
            genre = KPOP_GENRE;
            break;
    }

    return genre;
}

int main(string[] argv) {
    var genre_str = "jpop";
    var ui_str = "gui";

    GLib.OptionEntry[] entries = {
        {"genre", 'g', GLib.OptionFlags.NONE, GLib.OptionArg.STRING, ref genre_str, "Genre to start listening to"},
        {"ui", 'u', GLib.OptionFlags.NONE, GLib.OptionArg.STRING, ref ui_str, "UI to run (cli or gui)"},
    };

    var context = new GLib.OptionContext();
    context.add_main_entries(entries, null);

    try {
        context.parse(ref argv);

        var genre = genre_picker(genre_str);

        if (genre == null) {
            // Invalid genre
            return -1;
        }

        Gst.init(ref argv);
        var player = new Player(genre.stream);
        var ws = new Websocket(genre.ws);

        int code = -1;

        if (ui_str == "cli") {
            code = cli(player, ws);
        } else if (ui_str == "gui") {
            code = gui(player, ws, argv);
        }
    
        // Cleanup
        print("Bye!");
        ws.disconnect();
        player.stop();
        return code;
    } catch (GLib.OptionError e) {
        print(e.message);
    }

    return 1;
}
