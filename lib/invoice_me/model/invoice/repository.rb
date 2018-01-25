module InvoiceMe
  class InvoiceRepository
    def initialize(cuentica_client)
      @cuentica_client = cuentica_client
    end

    def put(invoice)
      expense_args = serialize(invoice)
      entry = @cuentica_client.register_expense(expense_args)
      raise InvalidInvoiceError, entry if(entry["message"])
      deserialize(entry)
    end

    def find_by_provider(provider_id)
      entries = @cuentica_client.get_expenses(provider: provider_id)
      entries.map { |entry|  deserialize(entry)}
    end

    private

    def deserialize(entry)
      Invoice.new(
        id: entry["id"],
        document_number: entry["document_number"],
        date: entry["date"],
        provider_id: entry["provider"]["id"],
        lines: deserialize_lines(entry["expense_lines"])
      )
    end

    def deserialize_lines(expense_lines)
      expense_lines.map do |expense_line|
        {
          description: expense_line['description'],
          base: expense_line['base'],
          vat: expense_line['vat'],
          retention: expense_line['retention'],
          expense_type: expense_line['expense_type']
        }
      end
    end

    def serialize(invoice)
      args = {document_type: 'invoice', draft: false}
      args[:document_number] = invoice.document_number
      args[:date] = invoice.date.to_s
      args[:provider] = invoice.provider_id

      args[:expense_lines] = serialize_expense_lines(invoice.lines)
      args[:payments] = serialize_payment_information(invoice)
      args[:attachment] = serialize_attachment(invoice)
      args
    end

    def serialize_expense_lines(lines)
      expense_lines = []
      lines.each do |line|
        expense_line = line.to_h
        expense_line[:investment] = false
        expense_line[:imputation] = 100
        expense_line[:expense_type] = '6230005'
        expense_lines.push(expense_line)
      end
      expense_lines
    end

    def serialize_payment_information(invoice)
      origin_account = ENV['ORIGIN_ACCOUNT'].to_i
      date = invoice.date.to_s
      [{date: date, amount: invoice.total_amount, payment_method: 'wire_transfer', paid: false, origin_account: origin_account}]
    end

    def serialize_attachment(invoice)
      require "base64"

      return unless invoice.attachment
      {
        filename: invoice.attachment.filename,
        data: Base64.strict_encode64(invoice.attachment.data)
      }
    end
  end
end
