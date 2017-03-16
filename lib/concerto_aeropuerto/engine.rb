module ConcertoAeropuerto
  class Engine < ::Rails::Engine
    isolate_namespace ConcertoAeropuerto

    initializer "register content type" do |app|
      app.config.content_types << Aeropuerto
    end

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do
        add_route("concerto_aeropuerto", ConcertoAeropuerto::Engine)
      end
    end
  end
end
