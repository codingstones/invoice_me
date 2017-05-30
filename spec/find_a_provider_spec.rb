describe "Find A Prodiver" do
  it "find an existing provider" do
    finder = Cuentica::FindAProvider.new()

    dani = finder.run("73208234Q")

    expect(dani["cif"]).to eq "73208234Q"
  end
end
