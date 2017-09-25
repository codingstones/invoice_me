# Invoice Me

Esta es una pequeña aplicación web para recibir facturas de proveedores. En este caso integrado con [Cuéntica](https://cuentica.com/) a través de [su API](https://apidocs.cuentica.com/versions/latest_release/).

## Instrucciones para la puesta en marcha

Clona el proyecto:

    $ git clone git@github.com:codingstones/invoice_me.git

Instala las dependencias con bundler:

    $ bundle install

Una vez tengas tu token de cuéntica, puedes lanzarlo simplemente con ruby:

    $ AUTH_TOKEN=tu_token_de_cuentica ruby app.rb

O con cualquier un servidor Rack:

    $ AUTH_TOKEN=tu_token_de_cuentica bundle exec rackup -p 4567
