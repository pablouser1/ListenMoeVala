using Gst;

public class Player {
    private dynamic Element play;
    private bool playing = false;

    public Player(string stream) {
        play = ElementFactory.make("playbin", "play");
        play.uri = stream;
    }

    public void start() {
        play.set_state(State.PLAYING);
        playing = true;
    }

    public void stop() {
        play.set_state(State.NULL);
    }

    public void toggle() {
        if (playing) {
            play.set_state(State.PAUSED);
        } else {
            play.set_state(State.PLAYING);
        }

        playing = !playing;
    }

    public void changeStream(string stream) {
        var wasPlaying = playing;
        if (wasPlaying) {
            playing = false;
            stop();
        }

        play.uri = stream;

        if (wasPlaying) {
            start();
        }
    }
}
