import Array "mo:base/Array";   //thaw, freeze
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor{
    public type ChunkId = Nat;
    public type HeaderField = (Text, Text);
    public type StreamingStrategy = {
        #Callback : {
        token : StreamingCallbackToken;
        callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };
    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };
    public type HttpRequest = {
        url : Text;
        method : Text;
        body : [Nat8];
        headers : [HeaderField];
    };
    public type HttpResponse = {
        body : Blob;
        headers : [HeaderField];
        streaming_strategy : ?StreamingStrategy;
        status_code : Nat16;
    };
    public type Key = Text;
    public type Path = Text;
    public type SetAssetContentArguments = {
        key : Key;
        sha256 : ?[Nat8];
        chunk_ids : [ChunkId];
        content_encoding : Text;
    };
    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };

    stable var currentValue : Nat = 0;

    // Increment the counter with the increment function.
    public func increment() : async () {
        currentValue += 1;
    };

    // Read the counter value with a get function.
    public query func get() : async Nat {
        currentValue
    };

    // Write an arbitrary value with a set function.
    public func set(n: Nat) : async () {
        currentValue := n;
    };

    public shared query func http_request(request : HttpRequest) : async HttpResponse {
        {
            body = Text.encodeUtf8("<html><body> current value : "#debug_show(currentValue)#"</body></html>");
            headers = [];
            streaming_strategy = null;
            status_code = 200;
        }
    };

}
