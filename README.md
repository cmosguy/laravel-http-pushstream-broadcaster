# HTTP Push-Stream Nginx Module Laravel Broadcast Driver 

Thank your for your interest in the HTTP Push-stream Nginx broadcast driver for Laravel.  If you are here, it is because you are trying to leverage the latest feature within the Laravel 5.1 broadcasts events for websockets.  The HTTP Pushstream Module for Nginx is a powerful Websocket system.   



## Requirements

*  You must compile the Nginx module for 


## Installation

1. Do a composer require get this package: `composer require cmosguy/laravel-http-pushstream-broadcaster`

2. Next, go into your `config/broadcasting.php` file and add and adjust the following lines accordingly:
 
        'default' => pushstream,

        'pushstream' => [
            'driver' => 'pushstream',
            'base_url' => 'http://localhost',
            'access_key' => 'foo'
        ]
        

