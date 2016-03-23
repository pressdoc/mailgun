module Mailgun
  class Message
    MAX_TAGS=3
    MAX_RECIPIENTS=1000

    attr_accessor :from, :to, :cc, :bcc, :subject, :text, :html,
      :reply_to, :delivery_time, :campaign, :dkim, :testmode, :tags, :tracking, :variables

    def initialize(params = {})
      tracking = true
      params.each do |k, v|
        send(:"#{k}=", v) unless v.nil?
      end
      yield self if block_given?
    end

    def tags=(val=[])
      if val.is_a? String
        @tags = [val]
      elsif val.is_a? Array
        raise "Maximum of #{MAX_TAGS} tags supported" if val.count > MAX_TAGS
        @tags = val
      end
    end

    def to_h
      payload = {
        'from' => from,
        'to' => to,
        'cc' => cc,
        'bcc' =>  bcc,
        'subject' => subject,
        'text' => text,
        'html' => html,
        'o:campaign' => campaign,
        "o:deliverytime" => delivery_time.to_s,
        "o:dkim" => to_boolean_string(dkim),
        'o:tag' => tags,
        "o:testmode" => to_boolean_string(testmode),
        "o:tracking" => to_boolean_string(tracking),
        'h:Reply-To' => reply_to
      }.reject {|_, v| v.nil? || v.empty?}

      if variables
        variables.symbolize_keys!
        variables.each do |k, v|
          payload[v:"#{k}"] = v
        end
      end
      payload
    end

    private

    def to_boolean_string(val)
      return 'yes' if %w(true yes yep).include? val.to_s.downcase
      return 'no' if %w(false no nope).include? val.to_s.downcase
      val
    end
  end
end