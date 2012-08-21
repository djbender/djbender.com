class Rack::UseWww
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['RACK_ENV'] != 'production' || env['SEVER_NAME'] =~ /^www\./ 
      @app.call(env)
    else
      [ 301, { 'Location' => 'http://www.derekbender.me/', 'Content-Type' => 'text/html' }, [] ]
    end
  end
end
