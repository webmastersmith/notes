# Audio

## Tutorials

- <https://dev.to/salmaab/audio-and-video-html-tutorial-learn-how-to-add-sound-effects-videos-and-youtube-videos-to-your-website-44gb>

HTML audio element

- <https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement>
- <https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio>

```html
<figure>
  <figcaption>Listen to the T-Rex:</figcaption>
  <audio controls src="/media/cc0-audio/t-rex-roar.mp3">
    Your browser does not support the
    <code>audio</code> element.
  </audio>
</figure>
```

React

- <https://stackoverflow.com/questions/47686345/playing-sound-in-react-js>

Audio.jsx

```js
import React, { useState, useEffect } from "react";

const useAudio = url => {
  const [audio] = useState(new Audio(url));
  const [playing, setPlaying] = useState(false);

  const toggle = () => setPlaying(!playing);

  useEffect(() => {
      playing ? audio.play() : audio.pause();
    },
    [playing]
  );

  useEffect(() => {
    audio.addEventListener('ended', () => setPlaying(false));
    return () => {
      audio.removeEventListener('ended', () => setPlaying(false));
    };
  }, []);

  return [playing, toggle];
};

const Player = ({ url }) => {
  const [playing, toggle] = useAudio(url);

  return (
    <div>
      <button onClick={toggle}>{playing ? "Pause" : "Play"}</button>
    </div>
  );
```

# Video / iFrames

- <https://liqvidjs.org/docs/guide/overview/>
