require 'bunny'
$rabbitmq = Bunny.new(host: '127.0.0.1')
$rabbitmq.start
