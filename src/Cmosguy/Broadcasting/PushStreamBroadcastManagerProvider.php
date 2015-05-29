<?php

namespace Cmosguy\Broadcasting;

use Illuminate\Support\ServiceProvider;
use GuzzleHttp\Client;
use Cmosguy\Broadcasting\Broadcasters\PushStreamBroadcaster;


class PushStreamBroadcastManagerProvider extends ServiceProvider
{

    public function boot()
    {

        $this->app->make('Illuminate\Broadcasting\BroadcastManager')->extend('pushstream', function ($app, $config) {
            return new PushStreamBroadcaster(new Client([
                'base_url' => $config['base_url'],
                'query'    => [
                    'access_key' => $config['access_key']
                ]
            ]));
        });
    }

    /**
     * Register the service provider.
     *
     * @return void
     */
    public function register()
    {
    }


}
