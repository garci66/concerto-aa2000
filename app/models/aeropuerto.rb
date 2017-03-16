class Aeropuerto < DynamicContent
  DISPLAY_NAME = 'Aeropuerto'

  AIRPORTS = {
    'ezeiza' => 'Ezeiza (EZE)',
    'aeroparque' => 'Aeroparque (AEP)',
    'iguazu' => 'Iguazú (IGR)'   
  }

  INFO_TYPES = {
     'a' => 'Arrivals',
     'd' => 'Departures'
  }

  LANGUAGES = {
    'en' => 'English',
    'es' => 'Spanish'
  }

  def build_content
    require 'json'
    require 'net/http'
    require 'base64'
    require 'json'

    container="<head id='Head1'><meta diego='utf891'/><meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
        <meta name='viewport' content='width=device-width, user-scalable=yes' />
        <link rel='stylesheet' type='text/css' href='http://www.aa2000.com.ar/stylesheets/screen.min.css' />
        <link rel='stylesheet' type='text/css' href='http://www.aa2000.com.ar/stylesheets/menu-fullscreen.min.css' />
        <link rel='stylesheet' type='text/css' href='http://www.aa2000.com.ar/stylesheets/aeropuerto.min.css' />
        <style>
            .vuelos-tabla table.scrollvuelos-main tbody.minitable {
                display: block;
                height: 92vh;
            }
        </style>
        <script type='text/javascript' src='http://www.aa2000.com.ar/js/jquery-1.11.1.min.js'></script>
        <script type='text/javascript' src='http://www.aa2000.com.ar/js/list.min.js'></script>
        <script type='text/javascript'>
            $(document).ready(function () {
                organizaGrillaVuelos();
            })
            function organizaGrillaVuelos() {
                /* obtener hora del server */
                function getDate(offset) {
                    var now = new Date();
                    var hour = 60 * 60 * 1000;
                    var min = 60 * 1000;
                    return new Date(now.getTime() + (now.getTimezoneOffset() * min) + (offset * hour));
                }
                var dateCET = getDate(-3);
                nowTime = dateCET.getHours();

                if ($('#arribos table.scrollvuelos-main').find('tbody').find('tr.popup').length > 10) {
                    var nowTimeCalc = $('.listArribos .popup td.hora.stda:contains(' + nowTime + ':)');
                    while (nowTimeCalc.length < 1) {
                        nowTime = nowTime + 1;
                        var nowTimeCalc = $('.listArribos .popup td.hora.stda:contains(' + nowTime + ':)');
                    }
                    var positionNow = nowTimeCalc.offset().top - $('.listArribos').offset().top;
                    $('tbody.listArribos').animate({ scrollTop: positionNow }, 'fast');
                }
                if ($('#partidas table.scrollvuelos-main').find('tbody').find('tr.popup').length > 10) {
                    var nowTimeCalc = $('.listPartidas .popup td.hora.stda:contains(' + nowTime + ':)');
                    while (nowTimeCalc.length < 1) {
                        nowTime = nowTime + 1;
                        var nowTimeCalc = $('.listPartidas .popup td.hora.stda:contains(' + nowTime + ':)');
                    }
                    var positionNow = nowTimeCalc.offset().top - $('.listPartidas').offset().top;
                    $('tbody.listPartidas').animate({ scrollTop: positionNow }, 'fast');
                }
            }
        </script>
        </head>
        <body id='intro' class='intro-aep'>
        <h3 style='text-align:center'>" + \
        Aeropuerto::AIRPORTS[self.config['airport']] + \
          "</h3>
          <div class='vuelos-tabla' id='vuelos-tabla'>
          </div>
        </div>

        </body>
    </html>"
    

    uri= URI.parse('http://www.aa2000.com.ar/' + self.config['airport'])
    http = Net::HTTP.new(uri.host, uri.port)
    
    if self.config['language'] == 'en'
      initheader = {'X-MicrosoftAjax' => 'Delta=true', 'User-Agent' => 'Mozilla/5.0', 'Cookie' => 'Idioma=EN-US'}
    else
      # Do not set the language cookie
      initheader = {'X-MicrosoftAjax' => 'Delta=true', 'User-Agent' => 'Mozilla/5.0'}
    end

    req = Net::HTTP::Post.new(uri.path, initheader)

    if self.config['info_type'] == 'a'
      req.set_form_data( {'__EVENTTARGET' => 'CargarGrillaTimer'} )
      flightsDivId='#arribos'
    else
      req.set_form_data( {'__EVENTTARGET' => 'CargarGrillaTimer', 'chkDivPartidas' => 'true'} )
      flightsDivId='#partidas'
    end

    res=http.request(req)
    res.body.force_encoding('utf-8')
    body=res.body.split('|')[7]
    body.gsub!(/\r/, " ").gsub!(/>\s*</, "><")

    parsedBody=Nokogiri::HTML::fragment(body)
    containerNoko=Nokogiri::HTML(container)
    containerNoko.at('#vuelos-tabla').add_child(parsedBody.css(flightsDivId))

    html=containerNoko.to_s

    # Create Iframe content
    iframe = Iframe.new()
    iframe.name = "Flight " + Aeropuerto::INFO_TYPES[self.config['info_type']] + \
      " information for " + Aeropuerto::AIRPORTS[self.config['airport']] + \
      " in " + Aeropuerto::LANGUAGES[self.config['language']]
    iframe.data = JSON.dump( 'url' => "data:text/html;charset=utf-8;base64, " + Base64.strict_encode64(html))

    return [iframe]
  end



  # Aeropuerto needs a location.  Also allow specification of units
  def self.form_attributes
    attributes = super()
    attributes.concat([:config => [:airport, :language, :info_type]])
  end

end
