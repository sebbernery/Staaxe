package staaxe;

import haxe.Http;
import haxe.Json;
import haxe.Timer;


typedef InitOptions = {
    url:String,
    token:String,
    interval:Int
};

typedef Message = {
    key:String,
    value:String
};


/** This is a purely static class. To be used, you have to call the init function.
   If you want to check when it's correctly initialized, check if id is not null.
**/
class Staaxe {
    static public var id(default, null):Null<String>;

    static var url:String;
    static var token:String;
    static var interval:Int;

    static var queue = new Array<Message>();

    /** Init function, call it as soon as possible.
       take an InitOptions object in parameter :
         - url : the url of the Staaxe server
         - token : the token corresponding to the current game
         - interval : in second, how much time will separate each ping request.
    **/
    static public function init(options:InitOptions) {
        url = options.url;
        token = options.token;
        interval = options.interval;

        init_connection();
    }

    /** Send function : send a message to the server.
       A message has a key and a value
       (example : "end": "true" or "score": "457" or even "info": "Player found the sword").
       The now parameter indicate if messages must be sent right now
       or if it can wait the next bulk-send (following the interval configuration).
    **/
    public static function send(key:String, value:String, now=false) {
        queue.push({key: key, value: value});

        if (now) {
            send_request();
        }
    }

    static function init_connection() {
        var http = new Http(url + "/init");
        http.setPostData(Json.stringify({
            token: token
        }));

        http.onData = connection_initiated;
        http.request(true);
    }

    static function connection_initiated(data:String) {
        var ret = Json.parse(data);
        if (ret.error != null) {
            trace("Connection can't be initialized ...", ret.error);
            return;
        }
        id = ret.id;

#if (js || flash)
        var timer = new Timer(interval*1000);
        timer.run = regular_send;
#end
    }

    static function regular_send() {
        Staaxe.send_request();
    }

    static function send_request() {
        if (id == null) {
            // trace("Can't send anything now...");
            return;
        }
        var http = new Http(url + "/send");

        http.setPostData(Json.stringify({
            id: id,
            payload: queue
        }));
        http.onData = handle_send_response;
        http.request(true);
    }

    static function handle_send_response(data) {
        var ret = Json.parse(data);
        if (ret.error != null) {
            trace(ret.error);
        }
        queue.splice(0, ret.num_received);
    }
}

