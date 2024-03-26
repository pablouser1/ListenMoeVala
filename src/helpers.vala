public struct Album {
    string name;
    string cover;
}

public class Song {
    Json.Object root;

    public Song(Json.Object root) {
        this.root = root;
    }

    public string name() {
        return root.get_string_member("title");
    }

    public string artist() {
        var artists = root.get_array_member("artists");
        var artist = artists.get_object_element(0);
        var artistName = artist.get_string_member("name");
    
        return artistName;
    }

    public Album? album() {
        Album album;
    
        var albums = root.get_array_member("albums");
    
        var length = albums.get_length();
    
        if (length > 0) {
            var album_obj = albums.get_object_element(0);
    
            album = {
                album_obj.get_string_member("name"),
                album_obj.get_string_member("image"),
            };
    
            return album;
        }
    
        return null;
    }
}
