module BunnyCarrot
  class ExceptionNotifier
    SERVICES = [
        BunnyCarrot::ExceptionNotification::Airbrake
    ]

    def self.call(args)
      SERVICES.each do |service|
        service.notify(args)
      end
    end
  end
end
