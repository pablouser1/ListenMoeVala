public struct Album {
    string name;
    string cover;
}

public class Data {
    private string name = "";
    private string artist = "";
    private int64 listeners = 0;
    private Album? album = null;

    public Data(Json.Object song, int64 listeners) {
        setListeners(listeners);
        setName(song);
        setArtist(song);
        setAlbum(song);
    }

    public string getName() {
        return name;
    }

    public string getArtist() {
        return artist;
    }

    public Album? getAlbum() {
        return album;
    }

    public int64 getListeners() {
        return listeners;
    }

    private void setName(Json.Object song) {
        name = song.get_string_member("title");
    }

    private void setArtist(Json.Object song) {
        var artists = song.get_array_member("artists");
        var artistObj = artists.get_object_element(0);
        var artistName = artistObj.get_string_member("name");
    
        artist = artistName;
    }

    private void setAlbum(Json.Object song) {
        Album tmp;
    
        var albums = song.get_array_member("albums");
    
        var length = albums.get_length();
    
        if (length > 0) {
            var album_obj = albums.get_object_element(0);
    
            tmp = {
                album_obj.get_string_member("name"),
                album_obj.get_string_member("image"),
            };
    
            album = tmp;
        }
    
        album = null;
    }

    private void setListeners(int64 listeners) {
        this.listeners = listeners;
    }
}
