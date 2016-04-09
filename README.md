# Staaxe

Staaxe is a statical tool for games. It provides a very simple API to track and get infos on game's session.

```haxe
Staaxe.init({
    "http://your-staaxe-server",
    "token",
    20 // interval
});
```

First, you have to precise the Staaxe server (see https://github.com/sebbernery/staaxe-server ).
Second, you must provide an authorized token (corresponding to your game).
Eventually, provide the interval between requests. Here, the client will send a request to the server every 20 seconds.

To send specific data, use this method :

```haxe
Staaxe.send("score", "436");
Staaxe.send("ended", "true", true);
```

Staaxe is a static class.

You can access the api doc here : https://sebbernery.github.io/Staaxe/doc/staaxe/Staaxe.html .

The server will store every message it receive, with some metadata. So you can see how much time a gamer spend on your game, with only an Staaxe.init.
With some Staaxe.send, you can send messages containing progression of the player.

The client will stack every send message until next request. If you need to send a message right now, use "true" as third argument. It's usefull if you want to know
if the player finished the game (he may quit the game before the next request).

There is no statistical analysis tool. The result is a sqlite file.

WARNING: Staaxe has never been tested in real environment.

