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
      end if args[:lines]
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
    attr_reader :description, :base, :vat, :retention, :expense_type

    PROFESSIONAL_SERVICES_EXPENSE_TYPE = "623"
    def initialize(args)
      @description = args[:description]
      @base = args[:base]
      @vat = args[:vat]
      @retention = args[:retention]
      @expense_type = PROFESSIONAL_SERVICES_EXPENSE_TYPE
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
        :retention => @retention,
        :expense_type => @expense_type
      }
    end
  end

  class InvoiceRepository
    def initialize(cuentica_client)
      @cuentica_client = cuentica_client
    end

    def put(invoice)
      expense_args = map_invoice_to_expense(invoice)
      entry = @cuentica_client.register_expense(expense_args)

      Invoice.new(id: entry["id"])
    end

    def map_invoice_to_expense(invoice)
      args = {document_type: 'invoice', draft: false}
      args[:document_number] = invoice.document_number
      args[:date] = invoice.date.to_s
      args[:provider] = invoice.provider_id

      args[:expense_lines] = expense_lines_information(invoice.lines)
      args[:payments] = payment_information(invoice)
      args[:attachment] = attachment_information(invoice)
      args
    end

    def expense_lines_information(lines)
      expense_lines = []
      lines.each do |line|
        expense_line = line.to_h
        expense_line[:investment] = false
        expense_line[:imputation] = 100
        expense_lines.push(expense_line)
      end
      expense_lines
    end

    def payment_information(invoice)
      date = invoice.date.to_s
      [{date: date, amount: invoice.total_amount, payment_method: 'wire_transfer', paid: false, origin_account: 37207}]
    end

    def attachment_information(invoice)
      require "base64"

      return unless invoice.attachment
      {
        filename: invoice.attachment.filename,
        data: Base64.encode64(invoice.attachment.data)
      }
    end
  end
end
