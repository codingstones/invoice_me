describe "Find A Prodiver" do
  it "find an existing provider" do
    VCR.use_cassette("find_a_provider") do
      finder = Cuentica::FindAProvider.new()

      pepito_perez = finder.run("12345678Z")

      expect(pepito_perez["cif"]).to eq "12345678Z"
    end
  end
end
