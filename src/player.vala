using Gst;

public class Player {
    private dynamic Element play;
    private bool playing = false;
    public double vol = 1.0;

    public Player(string stream) {
        play = ElementFactory.make("playbin", "play");
        play.uri = stream;
        play.set("volume", vol);
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

    public void volume(double newVol) {
        vol = newVol;
        play.set("volume", vol);
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
