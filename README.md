# HTTP Push-Stream Nginx Module Laravel Broadcast Driver 

Thank your for your interest in the HTTP Push-stream Nginx broadcast driver for Laravel.  If you are here, it is because you are trying to leverage the latest feature within the Laravel 5.1 broadcasts events for websockets.  The [HTTP Pushstream Module for Nginx](https://github.com/wandenberg/nginx-push-stream-module) is a powerful Websocket system.   


# Why use HTTP Pushstream?
If you want to really absorb the power of this capability of this module then check out what the dev-ops from Discus thought in this link:

http://highscalability.com/blog/2014/4/28/how-disqus-went-realtime-with-165k-messages-per-second-and-l.html

# How does this driver work?
Once you setup all your routes for the pub/sub requests to the HTTP routes in in the `location` directives for *Nginx*, then you'll be able to quickly open a socket on your client use the **pushstream.js** push your broadcasts out.  The requests are internally called by the [GuzzleHttp](http://guzzle.readthedocs.org/en/latest/) package.  The `broadcasting.php` config file will use the **pushstream** driver where you can control the HTTP requests to the to your pub/sub endpoints.  

You can lock down your pub/sub nginx endpoints using the [Access Key Module](http://wiki.nginx.org/HttpAccessKeyModule).  Here you can configure the key 

## Requirements

*  **HTTP Pushstream Module:** You must compile the Nginx HTTP Pushstream module.  Here are some instructions on how to do it here for the module itself on github: 
    * [Github readme](https://github.com/wandenberg/nginx-push-stream-module#installation)
    * [Nginx module site](http://wiki.nginx.org/HttpPushStreamModule#instalation)
    * [I have made an Ubuntu install script](scripts/install_nginx_pushstream_module.sh)
    
*  **Acces Key Module** Also, if you want to use the `access_key` feature to the routes for the pub/sub then please also install the [Access Key Module](http://wiki.nginx.org/HttpAccessKeyModule)


## Installation

1. Do a composer require get this package: `composer require cmosguy/laravel-http-pushstream-broadcaster`

2. Next, go into your `config/broadcasting.php` file and add and adjust the following lines accordingly.  `base_url` refers to websocket root for your HTTP requests pub/sub routes:
 
        'default' => pushstream,

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
   
2.  In your config file for your routes in the `server {` section, obviously you need to understand and modify the items below but this is meant to just get your started.  If you want a more thorough config check out [this](https://gist.github.com/dctrwatson/0b3b52050254e273ff11#file-nginx-v):

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

        
## Disclaimer

This is by no means the only want to go about how this should work.  You need to understand what all the options do and there is definitely a a



