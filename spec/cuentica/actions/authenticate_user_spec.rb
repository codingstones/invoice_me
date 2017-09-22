describe "Authenticate a user" do
  before(:each) do
    @authenticate_a_user_action = Cuentica::Factory.new.authenticate_a_user_action
  end
  it "when the credentials are ok" do
    VCR.use_cassette("find_a_provider") do
      pepito_perez = @authenticate_a_user_action.run("12345678Z", "password")

      expect(pepito_perez.cif).to eq "12345678Z"
    end
  end

  it "when the credentials are wrong" do
    VCR.use_cassette("find_a_provider") do
      pepito_perez = @authenticate_a_user_action.run("12345678Z", "")

      expect(pepito_perez).to be_nil
    end
  end
end
