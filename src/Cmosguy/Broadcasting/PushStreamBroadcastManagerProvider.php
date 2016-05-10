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
            $client = new Client([
                'base_url' => $config['base_url'],
                'query'    => isset($config['access_key']) ? [
                    'access_key' => $config['access_key']
                ] : null
            ]);
            
            if (!empty($config['cert'])) {
                $client->setDefaultOption('verify', $config['cert']);
            }

            return new PushStreamBroadcaster($client);
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
