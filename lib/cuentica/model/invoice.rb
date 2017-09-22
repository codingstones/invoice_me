module Cuentica
  class Invoice
    attr_reader :id, :document_number, :lines, :date, :attachment, :provider_id

    def initialize(args)
      @id = args[:id]
      @date = args[:date]
      @document_number = args[:document_number]
      @provider_id = args[:provider_id]
      @lines = args[:lines].map do |line_args|
        Line.new(line_args)
      end
      @attachment = Attachment.new(args[:attachment]) if args[:attachment]
    end

    def total_amount
      total_amount = 0
      @lines.each do |line|
        total_amount += line.amount
      end
      total_amount
    end
  end

  class Attachment
    attr_reader :filename, :data

    def initialize(args)
      @filename = args[:filename]
      @data = args[:data]
    end
  end

  class Line
    attr_reader :description, :base, :vat, :retention

    def initialize(args)
      @description = args[:description]
      @base = args[:base]
      @vat = args[:vat]
      @retention = args[:retention]
    end

    def amount
      vat_amount = base*vat/100
      retention_amount = base*retention/100
      base + (vat_amount - retention_amount)
    end

    def to_h
      {
        :description => @description,
        :base => @base,
        :vat => @vat,
        :retention => @retention
      }
    end
  end
end
