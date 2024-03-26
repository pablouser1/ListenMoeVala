public class Websocket {
    private Soup.Session s = new Soup.Session();
    private Soup.WebsocketConnection? conn;
    private Json.Parser parser = new Json.Parser();

    public signal void on_new_song(Data data);
    private string url;

    public Websocket(string url) {
        this.url = url;
    }

    public async void connect() {
        var msg = new Soup.Message("GET", url);

        try {
            conn = yield s.websocket_connect_async(msg, null, null, 0, null);
            conn.message.connect(handler);

            conn.error.connect((e) => {
                error("Error while using WS: " + e.message + " " + e.code.to_string());
            });
            conn.closed.connect(() => {
                debug("WS CLOSED");
            });

            debug("WS CONNECTED\n");
        } catch (GLib.Error e) {
            error("WS Remote error: " + e.message + " " + e.code.to_string());
        }

    }

    public void disconnect() {
        if (conn != null) {
            conn.close(Soup.WebsocketCloseCode.NORMAL, null);
        }
    }

    private void handler(int id, GLib.Bytes data) {
        var msg = (string) data.get_data();
        try {
            parser.load_from_data(msg);
            var root = parser. get_root().get_object();
            var op = root.get_int_member_with_default("op", -1);

            if (op == 10) {
                // Heartbeat acknowledged
                debug("Heartbeat OK\n");
                return;
            }

            var d = root.get_object_member("d");
    
            if (d != null) {
                switch (op) {
                    case 0:
                        // Welcome message w/ heartbeat interval
                        var interval = d.get_int_member("heartbeat");
                        GLib.Timeout.add_full(GLib.Priority.DEFAULT, (uint) interval, heartbeat);
                        break;
                    case 1:
                        // Getting data
                        var song = d.get_object_member("song");
                        var listeners = d.get_int_member_with_default("listeners", 0);
                        if (song != null) {
                            on_new_song(new Data(song, listeners));
                        }
                        break;
                }
            }
        } catch (Error e) {
            error(@"Could not parse JSON, $(e.message)");
        }

        debug(@"Message received! ID: $id Message:\n$msg\n");
    }

    private bool heartbeat() {
        debug("Sending heartbeat\n");
        conn.send_text("{\"op\":9}");
        return true;
    }
}
