public int cli(Player player, Websocket ws) {
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

private void write_to_screen(Data data) {
    // Wipe screen
    print("\033[H\033[2J");

    print("Now playing:\n");
    var title = data.getName();
    print(@"Title: $title\n");

    var artist = data.getArtist();
    print(@"Artist: $artist\n");
    var album = data.getAlbum();
    if (album != null) {
        print(@"Album: $(album.name)\n");
    }
}
