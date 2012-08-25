class Rack::UseWww
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['SERVER_NAME'] == 'derekbender.me' || env['SERVER_NAME'] == 'djbender.com' || env['SERVER_NAME'] == 'www.derekbender.me'
      [ 301, { 'Location' => '//www.djbender.com', 'Content-Type' => 'text/html' }, [] ]
    else
      @app.call(env)
    end
  end
end
