describe Cuentica::Factory do
  factory = Cuentica::Factory.new

  factory.public_methods(false).each do |public_method|
    next unless factory.method(public_method).parameters.empty?
    description = description_for(public_method)

    context "when creating the #{description}" do
      it 'creates the object' do
        object = factory.send(public_method)

        expect(object).not_to be_nil
      end

      it 'creates the object only once' do
        object = factory.send(public_method)
        same_object = factory.send(public_method)

        expect(object).to eq(same_object)
      end
    end
  end
end
