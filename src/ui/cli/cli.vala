public int cli(Player player, Websocket ws, string[] argv) {
    // Allow JAP / KOR characters
    Intl.setlocale();

    var loop = new MainLoop();

    ws.on_new_song.connect((song) => {
        write_to_screen(song);
    });

    ws.connect.begin();
    player.start();

    loop.run();

    return 0;
}

private void write_to_screen(Song song) {
    // Wipe screen
    print("\033[H\033[2J");

    print("Now playing:\n");
    var title = song.name();
    print(@"Title: $title\n");

    var artist = song.artist();
    print(@"Artist: $artist\n");
    var album = song.album();
    if (album != null) {
        print(@"Album: $(album.name)\n");
    }
}
