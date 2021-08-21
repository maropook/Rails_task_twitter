module IsAmPm
extend ActiveSupport::Concern

    def is_am_pm
    time = Time.now
    if time.hour < 12 then
    @is_am = false
    end
    end

end
