describe "Authenticate a user" do
  it "when the credentials are ok" do
    VCR.use_cassette("find_a_provider") do
      finder = Cuentica::AuthenticateAUser.new()

      pepito_perez = finder.run("12345678Z", "password")

      expect(pepito_perez["cif"]).to eq "12345678Z"
    end
  end

  it "when the credentials are wrong" do
    VCR.use_cassette("find_a_provider") do
      finder = Cuentica::AuthenticateAUser.new()

      pepito_perez = finder.run("12345678Z", "")

      expect(pepito_perez).to be_nil
    end
  end
end
