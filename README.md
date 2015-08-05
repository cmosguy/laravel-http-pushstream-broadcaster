# HTTP Push-Stream Nginx Module Laravel Broadcast Driver 

Thank your for your interest in the HTTP Push-stream Nginx broadcast driver for Laravel.  If you are here, it is because you are trying to leverage the latest feature within the Laravel 5.1 broadcasts events for websockets.  The [HTTP Pushstream Module for Nginx](https://github.com/wandenberg/nginx-push-stream-module) is a powerful Websocket system.   


# Why use HTTP Pushstream?
If you want to really absorb the power of the capabilities of this module then check out what the dev-ops from [Disqus](http://disqus.com) thought in this link:

http://highscalability.com/blog/2014/4/28/how-disqus-went-realtime-with-165k-messages-per-second-and-l.html

# How does this driver work?
Once you setup all your routes for the pub/sub requests to the HTTP routes in the `location` directives for *Nginx*, then you'll be able to quickly open a socket on your client use the **pushstream.js** and push your broadcasts out using websocket or long-polling.  

The *pub/sub* requests are internally called by the [GuzzleHttp](http://guzzle.readthedocs.org/en/latest/) package.  The `broadcasting.php` config file will use the **pushstream** driver where you can control the HTTP requests to the to your pub/sub endpoints.  

You can lock down your pub/sub nginx endpoints using the [Access Key Module](http://wiki.nginx.org/HttpAccessKeyModule).  Here you can configure the key.

## Requirements

*  **HTTP Pushstream Module:** You must compile the Nginx HTTP Pushstream module. Here are some instructions on how to do it here for the module itself on github: 
    * [Github readme](https://github.com/wandenberg/nginx-push-stream-module#installation)
    * [Nginx module site](http://wiki.nginx.org/HttpPushStreamModule#instalation)
    * [I have made an Ubuntu install script](scripts/install_nginx_pushstream_module.sh)
    
*  **Acces Key Module** Also, if you want to use the `access_key` feature to the routes for the pub/sub then please also install the [Access Key Module](http://wiki.nginx.org/HttpAccessKeyModule).


## Installation

1. Do a composer require get this package: `composer require cmosguy/laravel-http-pushstream-broadcaster`

2. Next, go into your `config/broadcasting.php` file and add the following lines accordingly. `base_url` refers to websocket root for your HTTP requests pub/sub routes:
 
        'default' => 'pushstream',

        'pushstream' => [
            'driver' => 'pushstream',
            'base_url' => 'http://localhost',
            'access_key' => md5('foo')
        ]

3.  In your `config/app.php` add the following line to your `providers` array:

        'Cmosguy\Broadcasting\PushStreamBroadcastManagerProvider'
        
## Sample Nginx Configuration
1.  In your `/etc/nginx/nginx.conf` file add:

        push_stream_shared_memory_size 32M;
   
2.  Edit your config file for your routes in the `server {` section. Obviously, you need to understand and modify the items below. The following config information is just meant to get you started. If you want a more thorough config check out [this](https://gist.github.com/dctrwatson/0b3b52050254e273ff11#file-nginx-v):

        location /channels-stats {
            # activate channels statistics mode for this location
            push_stream_channels_statistics;

            # query string based channel id
            push_stream_channels_path               $arg_id;
        }

        location /pub {
           # activate publisher (admin) mode for this location
           push_stream_publisher admin;

            # query string based channel id
            push_stream_channels_path               $arg_id;
        }

        location ~ /sub/(.*) {
            # activate subscriber (streaming) mode for this location
            push_stream_subscriber;

            # positional channel path
            push_stream_channels_path                   $1;
        }

        location ~ /ws/(.*) {
            # activate websocket mode for this location
            push_stream_subscriber websocket;
        

            # positional channel path
            push_stream_channels_path                   $1;
            if ($arg_tests = "on") {
              push_stream_channels_path                 "test_$1";
            }

            # store messages in memory
            push_stream_store_messages              on;

            push_stream_websocket_allow_publish     on;

            if ($arg_qs = "on") {
              push_stream_last_received_message_time "$arg_time";
              push_stream_last_received_message_tag  "$arg_tag";
              push_stream_last_event_id              "$arg_eventid";
            }
        }
        
### Locking down the pub/sub endpoint

        location /pub {
           # activate publisher (admin) mode for this location
           push_stream_publisher admin;
           accesskey                on;
           accesskey_hasmethod      md5;
           accesskey_arg            "access_key";
           accesskey_signature      "mypass"

            # query string based channel id
            push_stream_channels_path               $arg_id;
        }

## Usage in your app

So, once you  are finally ready to trigger an event, you can do this easily now by just extending this `broadcastOn` in your event handler:

```php

<?php namespace App\Events;

use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class SomeEven implements ShouldBroadcast
{
    use SerializesModels;
    /**
     * @var Foo
     */
    public $foo;

    public function __construct(Foo $foo)
    {
        //
        $this->foo = $foo;
    }

    /**
     * Get the channels the event should be broadcast on.
     *
     * @return array
     */
    public function broadcastOn()
    {
        return ['foochannel-'.$this->foo->uuid];
    }
}

```
        
## The Client

Please download the **pushstream.js** from either following locations:

*  [The wandenberg/nginx-push-stream-module repository](https://raw.githubusercontent.com/wandenberg/nginx-push-stream-module/master/misc/js/pushstream.js)
*  Or you can go the bower route: `bower install pushstream`


## Study the Push Stream Module

At this time the only way to get more information from about the module and the capabilities is directly from the github repository, so do some reading here:

*  https://github.com/wandenberg/nginx-push-stream-module
*  See how the pushstream.js example works here: http://www.nginxpushstream.com/chat.html
*  Also read more about the pushstream.js here: https://github.com/wandenberg/nginx-push-stream-module/blob/master/docs/examples/websocket.textile#websocket-

        
# Disclaimer

This is by no means the only way to go about how this should work. You need to understand what all the options do and there is definitely a a

# Help
Please help me with updating this documentation. If it does not make sense or if you see something stupid let me know. Also, if there is a way to make this extend further and make it more flexible for others, please submit a PR to improve upon these.



