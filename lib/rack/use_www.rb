class Rack::UseWww
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['SERVER_NAME'] == 'derekbender.me'
      [ 301, { 'Location' => '//www.derekbender.me', 'Content-Type' => 'text/html' }, [] ]
    else
      @app.call(env)
    end
  end
end
